import Hyprland from "gi://AstalHyprland";
import Gtk from "gi://Gtk?version=4.0";

const hypr = Hyprland.get_default();

export function ActiveWorkspace(): Gtk.Label {
  const label = new Gtk.Label({
    css_classes: ["ws", "active", "ws-single"],
    xalign: 0.5,
  });

  function update() {
    label.set_label(String(hypr.focused_workspace?.id ?? ""));
  }

  update();
  hypr.connect("notify::focused-workspace", update);

  return label;
}
