import Gdk from "gi://Gdk?version=4.0";
import Gio from "gi://Gio";
import Gtk from "gi://Gtk?version=4.0";

import { createPoll } from "ags/time";
import { attachTooltip } from "tooltip";

const SCRIPT = "~/.config/hyprextra/scripts/volume.sh";

/* -----------------------------
 * Volume state (poll-only)
 * ----------------------------- */

interface VolumePayload {
  volume: number;
  icon: string;
}

export const volumeState = createPoll<VolumePayload | null>(
  null,
  1500,
  ["bash", "-lc", `${SCRIPT} --get && ${SCRIPT} --get-icon`],
  (stdout: string): VolumePayload | null => {
    try {
      const lines = stdout.trim().split("\n");
      if (lines.length < 2) return null;

      const volume = Number(lines[0]);
      const icon = lines[1];

      if (Number.isNaN(volume) || !icon) return null;

      return { volume, icon };
    } catch {
      return null;
    }
  },
);

// Start polling immediately
volumeState.subscribe(() => {});

/* -----------------------------
 * Volume pill widget
 * ----------------------------- */

export function VolumePill(): Gtk.Box {
  const box = new Gtk.Box({
    spacing: 6,
    css_classes: ["volume-pill", "pill"],
  });

  const iconImage = new Gtk.Image({
    pixel_size: 16,
  });

  const volLabel = new Gtk.Label({ label: "" });

  box.append(iconImage);
  box.append(volLabel);

  function update(): void {
    const state = volumeState();
    if (!state) return;

    iconImage.set_from_file(state.icon);
    volLabel.label = `${state.volume}%`;
  }

  update();
  const unsubscribe = volumeState.subscribe(update);

  /* Scroll: volume up/down */
  const scroll = new Gtk.EventControllerScroll({
    flags: Gtk.EventControllerScrollFlags.VERTICAL,
  });

  scroll.connect("scroll", (_c, _dx, dy) => {
    if (dy < 0) {
      // scroll up
      Gio.Subprocess.new(
        ["bash", "-lc", `${SCRIPT} --inc`],
        Gio.SubprocessFlags.NONE,
      );
    } else if (dy > 0) {
      // scroll down
      Gio.Subprocess.new(
        ["bash", "-lc", `${SCRIPT} --dec`],
        Gio.SubprocessFlags.NONE,
      );
    }
    return Gdk.EVENT_STOP;
  });

  const click = new Gtk.GestureClick();
  click.set_button(Gdk.BUTTON_PRIMARY);

  click.connect("released", () => {
    Gio.Subprocess.new(
      ["bash", "-lc", `${SCRIPT} --toggle`],
      Gio.SubprocessFlags.NONE,
    );
  });

  box.add_controller(click);

  /* Tooltip */
  attachTooltip(box, {
    text: () => {
      const state = volumeState();
      return state ? `Volume: ${state.volume}%` : "";
    },
    classes: () => ["state-info"],
  });

  /* Cleanup */
  (box as Gtk.Widget & { _cleanup?: () => void })._cleanup = () => {
    unsubscribe();
  };

  return box;
}
