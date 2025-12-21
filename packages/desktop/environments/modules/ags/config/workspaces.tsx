import Hyprland from "gi://AstalHyprland";
import Gtk from "gi://Gtk?version=4.0";

type Workspace = Hyprland.Workspace;

const hypr = Hyprland.get_default();

export function Workspaces() {
  let box: Gtk.Box | null = null;

  function render() {
    if (!box) return;

    // Clear children safely
    let child = box.get_first_child();
    while (child) {
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

      const label = new Gtk.Label({
        label: String(ws.id),
      });

      button.set_child(label);

      button.connect("clicked", () => {
        hypr.dispatch("workspace", String(ws.id));
      });

      box.append(button);
    }
  }

  return (
    <box
      class="workspaces pill"
      spacing={6}
      onRealize={(self: Gtk.Box) => {
        box = self;

        render();
        hypr.connect("notify::workspaces", render);
        hypr.connect("notify::focused-workspace", render);
      }}
    />
  );
}
