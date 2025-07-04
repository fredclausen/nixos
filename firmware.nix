{
  config,
  pkgs,
  lib,
  ...
}:
# KEEP THIS FOR FUTURE REFERENCE
# this is used in the import section of the flake
# (import ./firmware.nix) # FIXME: this is a workaround until the firmware is fixed. Bad version is 20250509
# # hardware.firmware = [ pkgs.linux-firmware ]; # FIXME: Remove this when the firmware is fixed. Bad version is 20250509
{
  nixpkgs.overlays = [
    (self: super: {
      linux-firmware = super.callPackage (
        {
          stdenvNoCC,
          fetchzip,
          lib,
          rdfind,
          which,
        }:

        stdenvNoCC.mkDerivation rec {
          pname = "linux-firmware";
          version = "20250410";

          src = fetchzip {
            url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
            hash = "sha256-tjDqviOMvrBoEG8+Yn+XqdBlIDfQUX0KK2kpW6/jed8=";
          };

          nativeBuildInputs = [
            rdfind
            which
          ];

          installFlags = [ "DESTDIR=$(out)" ];

          # Firmware blobs do not need fixing and should not be modified
          dontFixup = true;

          meta = with lib; {
            description = "Binary firmware collection packaged by kernel.org";
            homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
            license = licenses.unfreeRedistributableFirmware;
            platforms = platforms.linux;
            maintainers = with maintainers; [ fpletz ];
            priority = 6; # give precedence to kernel firmware
          };
          passthru.updateScript = ./update.sh;
        }
      ) { };
    })
  ];
}
