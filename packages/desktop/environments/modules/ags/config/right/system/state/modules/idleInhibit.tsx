import { createPoll } from "ags/time";
import type { Severity, SystemSignal } from "../helpers/normalize";
import { normalizeWaybar } from "../helpers/normalize";

const SCRIPT = "~/.config/hyprextra/scripts/idleinhibit-toolbar.sh";

interface IdleInhibitPayload {
  class?: string;
  text?: string;
  tooltip?: string;
}

function isIdleInhibitPayload(value: unknown): value is IdleInhibitPayload {
  return (
    typeof value === "object" &&
    value !== null &&
    ("class" in value || "text" in value || "tooltip" in value)
  );
}

export const idleInhibitState = createPoll<SystemSignal | null>(
  null,
  2000,
  ["bash", "-lc", SCRIPT],
  (stdout: string): SystemSignal | null => {
    try {
      const parsed: unknown = JSON.parse(stdout);

      if (!isIdleInhibitPayload(parsed)) {
        return null;
      }

      const cls = parsed.class;
      const severity: Severity = cls === "inactive" ? "idle" : "warn";

      return normalizeWaybar(parsed, { severity });
    } catch {
      return null;
    }
  },
);

// Start polling immediately
idleInhibitState.subscribe(() => {});
