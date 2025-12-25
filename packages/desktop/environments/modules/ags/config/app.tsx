import Gtk from "gi://Gtk?version=4.0";
import { Astal } from "ags/gtk4";
import App from "ags/gtk4/app";
import { VolumePill } from "right/speaker-volume/volume";
import { WindowWorkspacesPill } from "./center/window-workspaces-pill";
import { SystemTray } from "./left/sys-tray/tray";
import { StatePill } from "./right/system/state-pill";
import { TimePill } from "./right/time-pill/time-pill";

App.reset_css();
App.apply_css(`./style.css`);

App.start({
  main() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return [
      <window
        visible
        anchor={TOP | LEFT | RIGHT}
        class="bar"
        default_height={28}
      >
        <centerbox valign={Gtk.Align.CENTER}>
          <box $type="start" valign={Gtk.Align.CENTER}>
            <SystemTray />
          </box>

          <box $type="center" valign={Gtk.Align.CENTER}>
            <WindowWorkspacesPill />
          </box>

          <box $type="end" valign={Gtk.Align.CENTER}>
            <VolumePill />
            <TimePill />
            <StatePill />
          </box>
        </centerbox>
      </window>,
    ];
  },
});
