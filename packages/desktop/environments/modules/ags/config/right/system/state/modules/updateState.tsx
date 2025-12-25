import { createPoll } from "ags/time";
import type { SystemSignal } from "../helpers/normalize";
import { normalizeWaybar } from "../helpers/normalize";

export const updateState = createPoll<SystemSignal | null>(
  null,
  5000,
  ["bash", "-lc", "~/.config/hyprextra/scripts/waybar-updates.sh"],
  (stdout) => {
    try {
      const parsed = JSON.parse(stdout);

      const cls = parsed.class;
      const severity =
        cls === "reboot" ? "warn" : cls === "updates" ? "warn" : "idle";

      return normalizeWaybar(parsed, { severity });
    } catch {
      return null;
    }
  },
);

// Start polling immediately
updateState.subscribe(() => {});
