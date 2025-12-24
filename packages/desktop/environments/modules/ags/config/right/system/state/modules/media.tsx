import { createPoll } from "ags/time";
import type { SystemSignal } from "../helpers/normalize";
import { normalizeWaybar } from "../helpers/normalize";

export const mediaState = createPoll<SystemSignal | null>(
  null,
  2000,
  ["bash", "-lc", "/home/fred/.config/hyprextra/scripts/waybar-media.sh"],
  (stdout: string): SystemSignal | null => {
    try {
      const parsed: unknown = JSON.parse(stdout);
      return normalizeWaybar(parsed);
    } catch {
      return null;
    }
  },
);

// 🔑 Start polling immediately
mediaState.subscribe(() => {});
