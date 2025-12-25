import type { SystemSignal } from "./normalize";

export type Severity = "idle" | "info" | "warn" | "error";

export interface AggregatedSystemState {
  severity: Severity;
  icon: string | null;
  summary: string;
  sources: SystemSignal[];
}

const severityRank: Record<Severity, number> = {
  error: 3,
  warn: 2,
  info: 1,
  idle: 0,
};

const ICON_PRIORITY: string[] = [
  "audio",
  "mic",

  // Idle inhibitors (should surface before updates)
  "caffeine",
  "external",

  // System state
  "reboot",
  "updates",
];

export function resolveSystemState(
  states: Array<SystemSignal | null>,
): AggregatedSystemState {
  const active: SystemSignal[] = states.filter(
    (s): s is SystemSignal =>
      s !== null && (s.severity !== "idle" || s.contextual === true),
  );

  if (active.length === 0) {
    return {
      severity: "idle",
      icon: null,
      summary: "All systems normal",
      sources: [],
    };
  }

  const top = active.sort(
    (a, b) => severityRank[b.severity] - severityRank[a.severity],
  )[0];

  // Determine icon independently of severity
  let icon: string | null = null;

  for (const category of ICON_PRIORITY) {
    const match = active.find((s) => s.category === category);
    if (match?.icon) {
      icon = match.icon;
      break;
    }
  }

  // Fallback: use highest-severity icon
  if (!icon) {
    icon = top.icon;
  }

  return {
    severity: top.severity,
    icon,
    summary: top.summary,
    sources: active,
  };
}
