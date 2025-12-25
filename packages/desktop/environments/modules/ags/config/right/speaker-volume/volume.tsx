import Gdk from "gi://Gdk?version=4.0";
import Gio from "gi://Gio";
import Gtk from "gi://Gtk?version=4.0";

import { createPoll } from "ags/time";
import { attachTooltip } from "tooltip";

const SCRIPT = "~/.config/hyprextra/scripts/volume.sh";

const ICONS = ["󰝟", "", "", ""];

function getIcon(volume: number | "Muted"): string {
  if (volume === "Muted") return ICONS[0];
  if (volume <= 20) return ICONS[1];
  if (volume <= 60) return ICONS[2];
  if (volume <= 80) return ICONS[3];
  return ICONS[4];
}

/* -----------------------------
 * Volume state (poll-only)
 * ----------------------------- */

type VolumeValue = number | "Muted";

interface VolumePayload {
  volume: VolumeValue;
  sink: string;
}

export const volumeState = createPoll<VolumePayload | null>(
  null,
  1500,
  ["bash", "-lc", `${SCRIPT} --get-bar && ${SCRIPT} --get-sink-name`],
  (stdout: string): VolumePayload | null => {
    try {
      const lines = stdout.trim().split("\n");
      if (lines.length < 2) return null;

      const rawVolume = lines[0];
      const sink = lines[1];

      const volume: VolumeValue =
        rawVolume === "Muted" ? "Muted" : Number(rawVolume);

      if (volume !== "Muted" && Number.isNaN(volume)) return null;

      return { volume, sink };
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

  const iconLabel = new Gtk.Label({ label: "" });
  const volLabel = new Gtk.Label({ label: "" });

  box.append(iconLabel);
  box.append(volLabel);

  function update(): void {
    const state = volumeState();
    if (!state) return;

    iconLabel.set_text(getIcon(state.volume));
    volLabel.label = state.volume === "Muted" ? "Muted" : `${state.volume}%`;
  }

  update();
  const unsubscribe = volumeState.subscribe(update);

  /* Scroll: volume up/down */
  const scroll = new Gtk.EventControllerScroll({
    flags: Gtk.EventControllerScrollFlags.VERTICAL,
  });

  scroll.connect("scroll", (_c, _dx, dy) => {
    if (dy < 0) {
      Gio.Subprocess.new(
        ["bash", "-lc", `${SCRIPT} --inc`],
        Gio.SubprocessFlags.NONE,
      );
    } else if (dy > 0) {
      Gio.Subprocess.new(
        ["bash", "-lc", `${SCRIPT} --dec`],
        Gio.SubprocessFlags.NONE,
      );
    }
    return Gdk.EVENT_STOP;
  });

  box.add_controller(scroll);

  /* Click: toggle mute */
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
      if (!state) return "";

      return `${state.sink}`;
    },
    classes: () => ["volume-pill"],
  });

  /* Cleanup */
  (box as Gtk.Widget & { _cleanup?: () => void })._cleanup = () => {
    unsubscribe();
  };

  return box;
}
