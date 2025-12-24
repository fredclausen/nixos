import Gtk from "gi://Gtk?version=4.0";
import { attachTooltip } from "tooltip";
import type { AggregatedSystemState } from "./state/helpers/aggregate";
import type { SystemSignal } from "./state/helpers/normalize";
import { systemState } from "./state/modules/system";

// Neutral icon shown when system is idle
const IDLE_ICON = "󰒓";

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

  /* Tooltip — dynamic, state-driven */
  attachTooltip(box, {
    text: () => {
      const state = systemState();

      if (state.sources.length === 0) {
        return "All systems normal";
      }

      return state.sources
        .map((s: SystemSignal) => `${s.icon ?? "•"} ${s.summary}`)
        .join("\n");
    },

    classes: () => {
      const state = systemState();
      return [`state-${state.severity}`];
    },
  });

  // Cleanup hook
  (box as Gtk.Widget & { _cleanup?: () => void })._cleanup = () => {
    unsubscribe();
  };

  return box;
}
