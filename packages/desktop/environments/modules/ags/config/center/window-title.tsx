import Hyprland from "gi://AstalHyprland";
import Gio from "gi://Gio";
import Gtk from "gi://Gtk?version=4.0";
import Pango from "gi://Pango?version=1.0";

const hypr = Hyprland.get_default();

let currentClient: Hyprland.Client | null = null;
let titleHandlerId: number | null = null;

function resolveAppIcon(appClass?: string): Gio.Icon | null {
  if (!appClass) return null;

  // 1️⃣ Try matching desktop file
  const appInfo = Gio.AppInfo.get_all().find((app) =>
    app.get_id()?.toLowerCase().includes(appClass.toLowerCase()),
  );

  if (appInfo) {
    const icon = appInfo.get_icon();
    if (icon) return icon;
  }

  // 2️⃣ Fallback: treat class as icon name
  try {
    return Gio.ThemedIcon.new(appClass);
  } catch {
    return null;
  }
}

export function WindowTitle(): Gtk.Box {
  let label: Gtk.Label;
  let image: Gtk.Image;

  function update() {
    const client = hypr.focused_client;

    // Disconnect from old client
    if (currentClient && titleHandlerId !== null) {
      currentClient.disconnect(titleHandlerId);
      titleHandlerId = null;
    }

    currentClient = client;

    if (client) {
      titleHandlerId = client.connect("notify::title", () => {
        label.set_label(client.title ?? "");
        label.set_max_width_chars(10);
      });

      label.set_label(client.title ?? "");
      label.set_max_width_chars(10);

      const icon = resolveAppIcon(client.class);
      if (icon) {
        image.set_from_gicon(icon);
        image.set_visible(true);
      } else {
        image.set_visible(false);
      }
    } else {
      label.set_label("");
      image.set_visible(false);
    }
  }

  image = new Gtk.Image({
    pixel_size: 16,
    visible: false,
  });

  label = new Gtk.Label({
    xalign: 0.5,
    ellipsize: Pango.EllipsizeMode.END,
    hexpand: true,
  });

  label.set_max_width_chars(10);

  const box = new Gtk.Box({
    spacing: 6,
    halign: Gtk.Align.CENTER,
    css_classes: ["window-title", "pill"],
  });

  box.append(image);
  box.append(label);

  update();
  hypr.connect("notify::focused-client", update);
  hypr.connect("notify::focused-title", update);
  hypr.connect("client-added", update);
  hypr.connect("client-removed", update);
  hypr.connect("client-moved", update);

  return box;
}
