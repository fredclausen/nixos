module.exports = {
  // Accept tags like:
  //   trixie-latest-build-4
  //   latest-build-14
  //   bullseye-build-204
  // Extract only the final number.
  parse(version) {
    const m = version.match(/(\d+)\s*$/);
    if (!m) return null;
    return { release: parseInt(m[1], 10) };
  },

  // Compare based only on the trailing build number
  compare(a, b) {
    return a.release - b.release;
  },

  isValid(version) {
    return /\d+$/.test(version);
  },
};
