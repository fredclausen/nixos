import App from "ags/gtk4/app";
import { Astal } from "ags/gtk4";
import { Workspaces } from "./workspaces";
import { WindowTitle } from "./window-title";
import { SystemTray } from "./tray";

App.reset_css();
App.apply_css(`./style.css`);

App.start({
  main() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return [
      <window visible anchor={TOP | LEFT | RIGHT} class="bar">
        <centerbox>
          <box $type="start">
            <Workspaces />
            <SystemTray />
          </box>

          <box $type="center">
            <WindowTitle />
          </box>

          <box $type="end" />
        </centerbox>
      </window>,
    ];
  },
});
