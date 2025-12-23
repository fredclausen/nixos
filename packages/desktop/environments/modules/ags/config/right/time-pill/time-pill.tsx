// time-pill.tsx

import GLib from "gi://GLib?version=2.0";
import Gtk from "gi://Gtk?version=4.0";

type WorldClock = {
  label: string;
  tzid: string;
};

const CLOCKS: WorldClock[] = [
  { label: "Local", tzid: "" },
  { label: "UTC", tzid: "UTC" },
  { label: "New York", tzid: "America/New_York" },
  { label: "London", tzid: "Europe/London" },
  { label: "Tokyo", tzid: "Asia/Tokyo" },
];

function nowIn(tzid: string): GLib.DateTime | null {
  try {
    if (!tzid) return GLib.DateTime.new_now_local();
    return GLib.DateTime.new_now(GLib.TimeZone.new(tzid));
  } catch {
    return null;
  }
}

export function TimePill(): Gtk.Button {
  let hovered = false;
  let expanded = false;
  let popoverOpen = false;

  /* ───────── Button ───────── */

  const button = new Gtk.Button({
    css_classes: ["time-pill", "pill"],
    focusable: false,
  });

  /* ───────── Content ───────── */

  const row = new Gtk.Box({
    orientation: Gtk.Orientation.HORIZONTAL,
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER,
  });

  const shortLabel = new Gtk.Label({
    css_classes: ["time-label", "time-short"],
    xalign: 0.5,
  });

  // Stabilize width to prevent geometry churn
  shortLabel.set_width_chars(8);
  shortLabel.set_max_width_chars(8);

  const longLabel = new Gtk.Label({
    css_classes: ["time-label", "time-long"],
    xalign: 0.5,
  });

  row.append(shortLabel);
  row.append(longLabel);
  button.set_child(row);

  /* ───────── Popover ───────── */

  const popover = new Gtk.Popover({
    has_arrow: false,
    autohide: true,
  });

  popover.set_parent(button);
  popover.set_position(Gtk.PositionType.BOTTOM);
  popover.set_halign(Gtk.Align.START);

  const popRoot = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 8,
    css_classes: ["time-popover"],
  });

  popRoot.set_hexpand(true);
  popRoot.set_halign(Gtk.Align.FILL);
  popover.set_child(popRoot);

  const title = new Gtk.Label({
    label: "World Clocks",
    css_classes: ["time-popover-title"],
    xalign: 0.0,
  });

  const clocksBox = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 6,
  });

  popRoot.append(title);
  popRoot.append(clocksBox);

  const clockLabels = new Map<string, Gtk.Label>();

  for (const c of CLOCKS) {
    const line = new Gtk.Box({
      orientation: Gtk.Orientation.HORIZONTAL,
      spacing: 10,
      hexpand: true,
    });

    const left = new Gtk.Label({
      label: c.label,
      xalign: 0.0,
      hexpand: true,
    });

    const right = new Gtk.Label({
      label: "--:--",
      xalign: 1.0,
    });

    line.append(left);
    line.append(right);
    clocksBox.append(line);
    clockLabels.set(c.tzid, right);
  }

  /* ───────── Helpers ───────── */

  function applyExpanded(next: boolean) {
    if (expanded === next) return;
    expanded = next;

    if (expanded) button.add_css_class("expanded");
    else button.remove_css_class("expanded");

    updateLabels();
  }

  function updateLabels() {
    const now = GLib.DateTime.new_now_local();

    // Always update short time
    shortLabel.set_label(now.format("%H:%M:%S") ?? "");

    // Do NOT change long label while popover is open
    if (!popoverOpen) {
      longLabel.set_label(expanded ? (now.format(" %A, %B %e, %Y") ?? "") : "");
    }

    if (popoverOpen) {
      for (const c of CLOCKS) {
        const dt = nowIn(c.tzid);
        const lbl = clockLabels.get(c.tzid);
        if (lbl) lbl.set_label(dt?.format("%H:%M") ?? "--:--");
      }
    }
  }

  function sizePopoverToMonitorEdge() {
    const display = button.get_display();
    const native = button.get_native();
    const surface = native?.get_surface();
    if (!display || !surface) return;

    const monitor = display.get_monitor_at_surface(surface);
    if (!monitor) return;

    const geo = monitor.get_geometry();

    const root = button.get_root();
    if (!(root instanceof Gtk.Widget)) return;

    const [ok, xInRoot] = button.translate_coordinates(root, 0, 0);
    if (!ok) return;

    // Remaining width from button's left edge to monitor's right edge
    const remaining = geo.width - xInRoot;

    popRoot.set_size_request(Math.max(remaining, 200), -1);
  }

  /* ───────── Tick ───────── */

  GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
    updateLabels();
    return GLib.SOURCE_CONTINUE;
  });

  /* ───────── Hover ───────── */

  const motion = new Gtk.EventControllerMotion();

  motion.connect("enter", () => {
    hovered = true;
    if (popoverOpen) return;
    scheduleExpand();
  });

  motion.connect("leave", () => {
    hovered = false;
    if (popoverOpen) return;
    scheduleCollapse();
  });

  button.add_controller(motion);

  let expandTimeoutId: number | null = null;
  let collapseTimeoutId: number | null = null;

  const EXPAND_DELAY_MS = 1500;
  const COLLAPSE_DELAY_MS = 400; // tweak to taste (250–600 feels “normal”)

  function clearTimeoutId(id: number | null): null {
    if (id !== null) GLib.source_remove(id);
    return null;
  }

  function scheduleExpand() {
    expandTimeoutId = clearTimeoutId(expandTimeoutId);
    collapseTimeoutId = clearTimeoutId(collapseTimeoutId);

    expandTimeoutId = GLib.timeout_add(
      GLib.PRIORITY_DEFAULT,
      EXPAND_DELAY_MS,
      () => {
        expandTimeoutId = null;
        if (hovered && !popoverOpen) applyExpanded(true);
        return GLib.SOURCE_REMOVE;
      },
    );
  }

  function scheduleCollapse() {
    expandTimeoutId = clearTimeoutId(expandTimeoutId);
    collapseTimeoutId = clearTimeoutId(collapseTimeoutId);

    collapseTimeoutId = GLib.timeout_add(
      GLib.PRIORITY_DEFAULT,
      COLLAPSE_DELAY_MS,
      () => {
        collapseTimeoutId = null;
        // only collapse if we’re still not hovered and popover isn’t open
        if (!hovered && !popoverOpen) applyExpanded(false);
        return GLib.SOURCE_REMOVE;
      },
    );
  }

  /* ───────── Click ───────── */

  button.connect("clicked", () => {
    if (popoverOpen) {
      popover.popdown();
      return;
    }

    popoverOpen = true;

    // Freeze label state for popover lifetime
    if (!expanded) {
      longLabel.set_label("");
      button.remove_css_class("expanded");
    } else {
      longLabel.set_label(
        GLib.DateTime.new_now_local().format(" %A, %B %e, %Y") ?? "",
      );
      button.add_css_class("expanded");
    }

    GLib.idle_add(GLib.PRIORITY_DEFAULT_IDLE, () => {
      sizePopoverToMonitorEdge();
      popover.popup();
      updateLabels();
      return GLib.SOURCE_REMOVE;
    });
  });

  popover.connect("closed", () => {
    popoverOpen = false;

    // resume hover-driven behavior smoothly:
    if (hovered) scheduleExpand();
    else scheduleCollapse();

    updateLabels();
  });

  updateLabels();
  return button;
}
