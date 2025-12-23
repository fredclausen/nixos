import Gtk from "gi://Gtk?version=4.0";
import { ActiveWorkspace } from "./active-workspace";
import { WindowTitle } from "./window-title";
import { Workspaces } from "./workspaces";

export function WindowWorkspacesPill(): Gtk.Box {
  const activeWs = ActiveWorkspace();
  const workspaces = Workspaces();
  const title = WindowTitle();

  const revealer = new Gtk.Revealer({
    transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
    transition_duration: 180,
    reveal_child: false,
  });

  revealer.set_child(workspaces);

  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["pill", "window-workspaces"],
    halign: Gtk.Align.CENTER,
    valign: Gtk.Align.CENTER,
  });

  // LEFT → RIGHT
  box.append(activeWs);
  box.append(revealer);
  box.append(title);

  const motion = new Gtk.EventControllerMotion();

  motion.connect("enter", () => {
    activeWs.set_visible(false);
    revealer.set_reveal_child(true);
  });

  motion.connect("leave", () => {
    revealer.set_reveal_child(false);
    activeWs.set_visible(true);
  });

  box.add_controller(motion);

  return box;
}
