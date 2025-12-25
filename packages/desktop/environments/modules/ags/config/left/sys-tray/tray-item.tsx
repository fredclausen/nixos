import AstalTray from "gi://AstalTray";
import Gdk from "gi://Gdk?version=4.0";
import Gtk from "gi://Gtk?version=4.0";
import { attachTooltip } from "tooltip";

type TrayItem = AstalTray.TrayItem;

type TrayButton = Gtk.Button & {
  _popover?: Gtk.PopoverMenu | null;
  _cleanup?: () => void;
};

// ---- Global "only one popover open" state ----
let OPEN_POPOVER: Gtk.PopoverMenu | null = null;

function closeOpenPopover(): void {
  if (!OPEN_POPOVER) return;

  try {
    OPEN_POPOVER.popdown();
  } catch {
    // ignore
  }

  OPEN_POPOVER = null;
}

function ensurePopover(
  button: TrayButton,
  item: TrayItem,
): Gtk.PopoverMenu | null {
  if (!item.menu_model || !item.action_group) return null;

  if (!button._popover) {
    const popover = new Gtk.PopoverMenu({
      menu_model: item.menu_model,
      has_arrow: false,
    });

    popover.insert_action_group("dbusmenu", item.action_group);
    popover.set_parent(button);

    popover.connect("closed", () => {
      if (OPEN_POPOVER === popover) OPEN_POPOVER = null;
    });

    button._popover = popover;
  }

  return button._popover;
}

function popupMenu(button: TrayButton, item: TrayItem): void {
  const popover = ensurePopover(button, item);
  if (!popover) return;

  if (OPEN_POPOVER && OPEN_POPOVER !== popover) {
    closeOpenPopover();
  }

  OPEN_POPOVER = popover;
  popover.popup();
}

/* ------------------------------------------------------------------
 * Tooltip resolution (markup-aware)
 * ------------------------------------------------------------------ */
function resolveTooltipMarkup(item: AstalTray.TrayItem): string | null {
  // 1️⃣ Explicit markup string
  if (
    typeof item.tooltip_markup === "string" &&
    item.tooltip_markup.length > 0
  ) {
    return item.tooltip_markup;
  }

  // 2️⃣ Boxed tooltip object (Discord, 1Password, etc.)
  const tooltipObj = item.tooltip as unknown;
  if (tooltipObj && typeof tooltipObj === "object") {
    const anyTooltip = tooltipObj as {
      text?: string;
      markup?: string;
    };

    if (typeof anyTooltip.markup === "string" && anyTooltip.markup.length > 0) {
      return anyTooltip.markup;
    }

    if (typeof anyTooltip.text === "string" && anyTooltip.text.length > 0) {
      return anyTooltip.text;
    }
  }

  // 3️⃣ Title (udiskie, nm-applet)
  if (typeof item.title === "string" && item.title.length > 0) {
    return item.title;
  }

  // 4️⃣ Fallback
  if (typeof item.id === "string" && item.id.length > 0) {
    return item.id;
  }

  return null;
}

export function TrayItem(item: TrayItem): TrayButton {
  const image = new Gtk.Image({
    gicon: item.gicon ?? null,
    pixel_size: 16,
  });

  const button = new Gtk.Button({
    css_classes: ["tray-item"],
    focusable: false,
    child: image,
  }) as TrayButton;

  /* ----------------------------------------------------------------
   * Tooltip attachment (NEW)
   * ---------------------------------------------------------------- */
  const tooltip = resolveTooltipMarkup(item);
  if (tooltip) {
    attachTooltip(button, {
      text: () => tooltip,
      classes: () => ["tray"],
    });
  }

  // PRIMARY CLICK
  button.connect("clicked", () => {
    closeOpenPopover();

    try {
      if (item.category !== AstalTray.Category.APPLICATION) {
        popupMenu(button, item);
        return;
      }

      item.activate(0, 0);
    } catch (err) {
      console.error("Tray activate failed:", err);
    }
  });

  // SECONDARY CLICK: open menu
  const rightClick = new Gtk.GestureClick();
  rightClick.set_button(Gdk.BUTTON_SECONDARY);

  rightClick.connect("released", () => {
    closeOpenPopover();
    popupMenu(button, item);
  });

  button.add_controller(rightClick);

  // Cleanup for when SystemTray removes this widget
  button._cleanup = () => {
    if (button._popover && OPEN_POPOVER === button._popover) {
      closeOpenPopover();
    }

    if (button._popover) {
      try {
        button._popover.unparent();
      } catch {
        /* ignore */
      }
      button._popover = null;
    }
  };

  item.connect("notify::gicon", (event) => {
    image.set_from_gicon(event.gicon);
  });

  return button;
}
