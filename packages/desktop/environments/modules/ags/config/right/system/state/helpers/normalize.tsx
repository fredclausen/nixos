// Normalize Waybar-style JSON into FredBar signal shape

export type Severity = "idle" | "info" | "warn" | "error";

export interface SystemSignal {
  severity: Severity;
  category: string;
  icon: string | null;
  summary: string;
  raw?: unknown;
}

interface WaybarPayload {
  class?: string | string[];
  text?: string;
  tooltip?: string;
}

/**
 * Convert Waybar-style JSON output into a normalized SystemSignal.
 *
 * Returns null if the payload is unusable.
 */
export function normalizeWaybar(raw: unknown): SystemSignal | null {
  if (typeof raw !== "object" || raw === null) {
    return null;
  }

  const payload = raw as WaybarPayload;

  const classes: string[] = Array.isArray(payload.class)
    ? payload.class
    : typeof payload.class === "string"
      ? [payload.class]
      : [];

  let severity: Severity = "idle";

  if (classes.includes("critical") || classes.includes("error")) {
    severity = "error";
  } else if (classes.includes("warning")) {
    severity = "warn";
  } else if (classes.length > 0 && !classes.includes("idle")) {
    // any non-idle semantic state is informational
    severity = "info";
  }

  return {
    severity,
    category: classes[0] ?? "unknown",
    icon: payload.text ?? null,
    summary: payload.tooltip ?? "",
    raw,
  };
}
