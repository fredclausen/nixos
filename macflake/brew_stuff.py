# read in Brewfile to an array, skip lines that start with tap and vscode. Only valid lines will start with brew or cask
# read the brews in to a list, and casks in another list

def get_brews_and_casks():
    brews = []
    casks = []
    with open("Brewfile", "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith("brew "):
                brew_name = line.split(" ")[1]
                brews.append(brew_name.strip().strip('"'))
            elif line.startswith("cask "):
                cask_name = line.split(" ")[1]
                casks.append(cask_name.strip().strip('"'))
    return brews, casks

# function to read in darwin.nix
# extract the casks from the casks array

def get_casks_from_darwin_nix():
    casks = []
    in_casks_section = False
    with open("darwin/default.nix", "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith("casks = ["):
                in_casks_section = True
                continue
            if in_casks_section:
                if line.startswith("]"):
                    break
                cask_name = line.strip().strip('"')
                casks.append(cask_name)
    return casks

# function to read in darwin.nix and extract brews
def get_brews_from_darwin_nix():
    brews = []
    in_brews_section = False
    with open("darwin/default.nix", "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith("brews = ["):
                in_brews_section = True
                continue
            if in_brews_section:
                if line.startswith("]"):
                    break
                brew_name = line.strip().strip('"')
                brews.append(brew_name)
    return brews

if __name__ == "__main__":
    brews, casks = get_brews_and_casks()
    nix_casks = get_casks_from_darwin_nix()
    nix_brews = get_brews_from_darwin_nix()

    # find casks that are in Brewfile but not in darwin.nix
    missing_casks = set(casks) - set(nix_casks)
    if missing_casks:
        print("\nCasks in Brewfile but not in darwin.nix:")
        for cask in missing_casks:
            print(f"\"{cask}\"")

    missing_brews = set(brews) - set(nix_brews)
    if missing_brews:
        print("\nBrews in Brewfile but not in darwin.nix:")
        for brew in missing_brews:
            print(f"\"{brew}\"")
