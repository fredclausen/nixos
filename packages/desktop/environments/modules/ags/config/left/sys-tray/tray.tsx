// tray.tsx

import Tray from "gi://AstalTray";
import Gtk from "gi://Gtk?version=4.0";
import { TrayItem } from "./tray-item";

interface DisposableWidget {
  _cleanup?: () => void;
}

const tray = Tray.get_default();

export function SystemTray(): Gtk.Box {
  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["tray", "pill"],
  });

  const items = new Map<string, Gtk.Widget>();

  function add(id: string) {
    const item = tray.get_item(id);
    if (!item) return;

    const widget = TrayItem(item);
    items.set(id, widget);
    box.append(widget);
  }

  function remove(id: string) {
    const widget = items.get(id);
    if (!widget) return;

    (widget as Gtk.Widget & DisposableWidget)._cleanup?.();

    box.remove(widget);
    items.delete(id);
  }

  // Initial population
  tray
    .get_items()
    .sort((a, b) => a.item_id.localeCompare(b.item_id))
    .forEach((item) => {
      add(item.item_id);
    });

  // Live updates
  tray.connect("item-added", (_, id) => add(id));
  tray.connect("item-removed", (_, id) => remove(id));

  return box;
}
