import { createPoll } from "ags/time";
import type { AggregatedSystemState } from "../helpers/aggregate";
import { resolveSystemState } from "../helpers/aggregate";

import { mediaState } from "../modules/media";

// later: cpuState, ramState, rebootState, etc

const INITIAL: AggregatedSystemState = {
  severity: "idle",
  icon: null,
  summary: "",
  sources: [],
};

/**
 * Aggregate all system signals into a single derived state.
 * We poll this because the underlying states (createPoll accessors)
 * do not expose a .connect() API in your setup.
 */
export const systemState = createPoll<AggregatedSystemState>(INITIAL, 250, () =>
  resolveSystemState([
    mediaState(),
    // cpuState(),
    // ramState(),
    // rebootState(),
  ]),
);
