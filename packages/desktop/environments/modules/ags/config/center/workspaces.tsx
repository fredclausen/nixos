import Hyprland from "gi://AstalHyprland";
import Gtk from "gi://Gtk?version=4.0";

type Workspace = Hyprland.Workspace;

const hypr = Hyprland.get_default();

export function Workspaces(): Gtk.Box {
  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["workspaces", "pill"],
    valign: Gtk.Align.CENTER,
  });

  function render() {
    // Clear children safely
    for (let child = box.get_first_child(); child; ) {
      const next = child.get_next_sibling();
      box.remove(child);
      child = next;
    }

    const workspaces: Workspace[] = (hypr.workspaces ?? [])
      .filter((ws: Workspace) => ws.id > 0)
      .sort((a: Workspace, b: Workspace) => a.id - b.id);

    const focusedId = hypr.focused_workspace?.id ?? null;

    for (const ws of workspaces) {
      const active = focusedId === ws.id;

      const button = new Gtk.Button({
        css_classes: active ? ["ws", "active"] : ["ws"],
        focusable: false,
      });

      const label = new Gtk.Label({ label: String(ws.id) });
      button.set_child(label);

      button.connect("clicked", () => {
        hypr.dispatch("workspace", String(ws.id));
      });

      box.append(button);
    }
  }

  render();
  hypr.connect("notify::workspaces", render);
  hypr.connect("notify::focused-workspace", render);

  return box;
}
