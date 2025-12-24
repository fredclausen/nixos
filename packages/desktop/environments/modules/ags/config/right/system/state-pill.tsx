import Gtk from "gi://Gtk?version=4.0";
import type { AggregatedSystemState } from "./state/helpers/aggregate";
import type { SystemSignal } from "./state/helpers/normalize";
import { systemState } from "./state/modules/system";

// Neutral icon shown when system is idle
const IDLE_ICON = "󰒓"; // pick whatever feels right later

export function StatePill(): Gtk.Box {
  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["state-pill", "pill", "state-idle"],
  });

  const iconLabel = new Gtk.Label({
    label: "",
  });

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

    if (isIdle) {
      iconLabel.label = IDLE_ICON;
      box.set_tooltip_text("All systems normal");
      return;
    }

    // Non-idle state
    iconLabel.label = state.icon ?? "";

    const tooltip = state.sources
      .map((s: SystemSignal) => `• ${s.summary}`)
      .join("\n");

    box.set_tooltip_text(tooltip);
  }

  // Initial render
  update();

  // Reactive updates (notification-only Accessor)
  const unsubscribe = systemState.subscribe(() => {
    update();
  });

  // Cleanup hook (matches your existing pattern)
  (box as Gtk.Widget & { _cleanup?: () => void })._cleanup = () => {
    unsubscribe();
  };

  return box;
}
