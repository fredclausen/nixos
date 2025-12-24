import { createPoll } from "ags/time";
import type { SystemSignal } from "../helpers/normalize";
import { normalizeWaybar } from "../helpers/normalize";

export const mediaState = createPoll<SystemSignal | null>(
  null,
  2000,
  ["bash", "-lc", "~/.config/hyprextra/scripts/waybar-media.sh"],
  (stdout) => {
    try {
      const parsed = JSON.parse(stdout);
      return normalizeWaybar(parsed, { severity: "info" });
    } catch {
      return null;
    }
  },
);

// 🔑 Start polling immediately
mediaState.subscribe(() => {});
