import Gtk from "gi://Gtk?version=4.0";

type CleanupWidget = Gtk.Widget & { _cleanup?: () => void };

interface TooltipOptions {
  text: () => string;
  classes?: () => string[] | string | null;
}

export function attachTooltip(anchor: Gtk.Widget, opts: TooltipOptions): void {
  anchor.has_tooltip = true;

  const handlerId = anchor.connect(
    "query-tooltip",
    (
      _widget: Gtk.Widget,
      _x: number,
      _y: number,
      _keyboardMode: boolean,
      tooltip: Gtk.Tooltip,
    ) => {
      const label = new Gtk.Label({
        label: opts.text(),
        wrap: true,
        xalign: 0,
      });

      const body = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
        css_classes: ["tooltip-body"],
      });

      body.append(label);

      const frame = new Gtk.Frame({
        css_classes: ["tooltip-frame"],
      });

      const cls = opts.classes?.();
      if (cls) {
        const list = Array.isArray(cls) ? cls : [cls];
        for (const c of list) {
          frame.add_css_class(c);
        }
      }

      frame.set_child(body);
      tooltip.set_custom(frame);
      return true;
    },
  );

  // Cleanup chaining
  (anchor as CleanupWidget)._cleanup = (() => {
    const prev = (anchor as CleanupWidget)._cleanup;
    return () => {
      anchor.disconnect(handlerId);
      prev?.();
    };
  })();
}
