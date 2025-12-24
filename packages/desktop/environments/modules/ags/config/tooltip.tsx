import Gtk from "gi://Gtk?version=4.0";

type CleanupWidget = Gtk.Widget & { _cleanup?: () => void };

interface TooltipOptions {
  text: () => string;
  classes?: () => string[] | string | null;
}

export function attachTooltip(anchor: Gtk.Widget, opts: TooltipOptions): void {
  anchor.has_tooltip = true;

  // FIXME: Cache because we have to regenerate this a fair bit on mouse move
  const handlerId = anchor.connect(
    "query-tooltip",
    (
      _widget: Gtk.Widget,
      _x: number,
      _y: number,
      _keyboardMode: boolean,
      tooltip: Gtk.Tooltip,
    ) => {
      const text = opts.text();
      if (!text || text.length === 0) {
        return false;
      }

      // --- CREATE FRESH WIDGETS EVERY TIME ---
      const label = new Gtk.Label({
        label: text,
        wrap: true,
        xalign: 0,
        use_markup: true,
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
        if (list.length === 0) {
          frame.add_css_class("state-idle-tooltip");
        } else {
          for (const c of list) {
            frame.add_css_class(`${c}-tooltip`);
          }
        }
      } else {
        frame.add_css_class("state-idle-tooltip");
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
