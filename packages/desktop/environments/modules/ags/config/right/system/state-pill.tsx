import GLib from "gi://GLib";
import Gtk from "gi://Gtk?version=4.0";
import { attachTooltip } from "tooltip";
import type { AggregatedSystemState } from "./state/helpers/aggregate";
import type { SystemSignal } from "./state/helpers/normalize";
import { systemState } from "./state/modules/system";

// Neutral icon shown when system is idle
const IDLE_ICON = "󰒓";

/* Semantic → color mapping (mirrors Catppuccin vars) */
const SEVERITY_COLOR: Record<string, string> = {
  idle: "#a6e3a1", // muted
  info: "#89b4fa", // blue
  warn: "#f9e2af", // yellow
  error: "#f38ba8", // red
};

function tooltipLineMarkup(s: SystemSignal): string {
  const icon = s.icon ?? "•";
  const color = SEVERITY_COLOR[s.severity] ?? SEVERITY_COLOR.idle;
  const summary = GLib.markup_escape_text(s.summary, -1);

  return `<span foreground="${color}">${icon}</span> ${summary}`;
}

export function StatePill(): Gtk.Box {
  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["state-pill", "pill", "state-idle"],
  });

  const iconLabel = new Gtk.Label({ label: "" });
  box.append(iconLabel);

  function update(): void {
    const state: AggregatedSystemState = systemState();

    // Reset severity classes
    box.remove_css_class("state-idle");
    box.remove_css_class("state-info");
    box.remove_css_class("state-warn");
    box.remove_css_class("state-error");

    box.add_css_class(`state-${state.severity}`);

    const isIdle = state.severity === "idle" && state.sources.length === 0;

    iconLabel.label = isIdle ? IDLE_ICON : (state.icon ?? "");
  }

  // Initial render
  update();

  // Reactive updates
  const unsubscribe = systemState.subscribe(update);

  /* Tooltip — dynamic, markup-driven */
  attachTooltip(box, {
    text: () => {
      const state = systemState();

      if (state.sources.length === 0) {
        return "All systems normal";
      }

      return state.sources.map(tooltipLineMarkup).join("\n");
    },

    classes: () => [`state-${systemState().severity}`],
  });

  // Cleanup hook
  (box as Gtk.Widget & { _cleanup?: () => void })._cleanup = () => {
    unsubscribe();
  };

  return box;
}
