import App from "ags/gtk4/app";
import { Astal } from "ags/gtk4";
import { WindowWorkspacesPill } from "./center/window-workspaces-pill";
import { SystemTray } from "./left/sys-tray/tray";

App.reset_css();
App.apply_css(`./style.css`);

App.start({
  main() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return [
      <window visible anchor={TOP | LEFT | RIGHT} class="bar">
        <centerbox>
          <box $type="start">
            <SystemTray />
          </box>

          <box $type="center">
            <WindowWorkspacesPill />
          </box>

          <box $type="end" />
        </centerbox>
      </window>,
    ];
  },
});
