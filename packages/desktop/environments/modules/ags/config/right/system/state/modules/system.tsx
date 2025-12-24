import { createPoll } from "ags/time";
import type { AggregatedSystemState } from "../helpers/aggregate";
import { resolveSystemState } from "../helpers/aggregate";

import { mediaState } from "../modules/media";
import { updateState } from "./updateState";

const INITIAL: AggregatedSystemState = {
  severity: "idle",
  icon: null,
  summary: "",
  sources: [],
};

export const systemState = createPoll<AggregatedSystemState>(INITIAL, 250, () =>
  resolveSystemState([mediaState(), updateState()]),
);
