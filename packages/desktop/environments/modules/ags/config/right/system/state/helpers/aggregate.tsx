export type Severity = "idle" | "info" | "warn" | "error";

export interface SystemSignal {
  severity: Severity;
  category: string;
  icon: string | null;
  summary: string;
  raw?: unknown;
}

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

export function resolveSystemState(
  states: Array<SystemSignal | null>,
): AggregatedSystemState {
  const active: SystemSignal[] = states.filter(
    (s): s is SystemSignal => s !== null && s.severity !== "idle",
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

  return {
    severity: top.severity,
    icon: top.icon,
    summary: top.summary,
    sources: active,
  };
}
