import Hyprland from "gi://AstalHyprland";
import Gtk from "gi://Gtk?version=4.0";
import Pango from "gi://Pango?version=1.0";

type Client = Hyprland.Client;

const hypr = Hyprland.get_default();

export function WindowTitle() {
  let label: Gtk.Label | null = null;

  function update() {
    if (!label) return;

    const client: Client | null = hypr.focused_client;
    label.set_label(client?.title ?? "");
  }

  return (
    <label
      class="window-title pill"
      xalign={0.5}
      ellipsize={Pango.EllipsizeMode.END}
      onRealize={(self) => {
        label = self as Gtk.Label;

        update();
        hypr.connect("notify::focused-client", update);

        // Runtime-valid but not always present in GIR;
        // safe to keep, harmless if unsupported
        hypr.connect("notify::focused-title", update);
      }}
    />
  );
}
