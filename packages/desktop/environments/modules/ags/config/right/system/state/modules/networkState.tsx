import { execAsync } from "ags/process";
import { createPoll } from "ags/time";
import type { Severity, SystemSignal } from "../helpers/normalize";

const ICONS = {
  vpn: "󰖂", // pick your preferred VPN glyph
  network: "󰖩",
  offline: "󰖪",
};

export const networkState = createPoll<SystemSignal | null>(
  null,
  3000,
  async (): Promise<SystemSignal | null> => {
    try {
      const connectivity = (
        await execAsync(["nmcli", "-t", "-f", "CONNECTIVITY", "general"])
      ).trim();

      const activeConnections = await execAsync([
        "nmcli",
        "-t",
        "-f",
        "TYPE,DEVICE,NAME",
        "connection",
        "show",
        "--active",
      ]);

      const vpnActive = activeConnections
        .split("\n")
        .some((line) => line.startsWith("vpn:"));

      let severity: Severity = "idle";
      let icon = ICONS.network;
      let summary = "Network connected";

      if (connectivity === "none") {
        severity = "error";
        icon = ICONS.offline;
        summary = "No network connection";
      } else if (connectivity === "portal") {
        severity = "warn";
        summary = "Captive portal detected";
      } else if (connectivity === "limited") {
        severity = "warn";
        summary = "Limited network connectivity";
      }

      if (vpnActive && severity !== "error") {
        icon = ICONS.vpn;
        summary = "VPN connected";
      }

      return {
        severity,
        category: "network",
        icon,
        summary,
        raw: {
          connectivity,
          vpnActive,
        },
        contextual: true,
      };
    } catch {
      return null;
    }
  },
);

// Start polling immediately
networkState.subscribe(() => {});
