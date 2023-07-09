# KotOR II Switch modding tools

This project is a group of tools to make modding the Nintendo Switch version of
Star Wars: Knights of the Old Republic II (aka. KotOR II) easier and less
confusing.

These scripts are by no means necessary, but they will help prevent common
issues that can occur.

**NOTE**: these modding tools will ONLY work for modded Nintendo Switches.

## Features

- Provide a folder structure that modding tools expect.
- Once modding is done, restructure the game folder to what the Switch expects.
- Call out potential issues along with instructions on how to fix them.
- Easy backups and restores during the modding process, to better see where
  things went wrong.

## Usage instructions

NOTE: It's **highly** recommended to read this entire section before starting.

### Prerequisites

- A computer (any OS, see notes below) to install mods with (mods cannot be
  installed directly on the Nintendo Switch).
  - **NOTE**: this project currently ONLY works with Bash, which is available
    by default on Linux and macOS. For Windows, please use either
    [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (recommended)
    or [Cygwin](https://www.cygwin.com).
    - An issue is already open for porting these scripts to PowerShell —
      contributions welcome via pull request.
- A modded Nintendo Switch with the
  [Atmosphère](https://github.com/Atmosphere-NX/Atmosphere) custom firmware
  installed.
  - **NOTE**: other custom firmwares will likely work but are unsupported.
- A copy of KotOR II already installed on the Nintendo Switch with all updates
  applied.
- [nxdumptool](https://github.com/DarkMatterCore/nxdumptool) installed on the
  Nintendo Switch to extract some game files needed for some mods.
- A way to interact with and transfer files to and from the Nintendo Switch.
  Examples:
  - [ftpd](https://github.com/mtheall/ftpd)
  - Hekate's tool to mount the SD Card to a PC, under **Tools** | **USB Tools**
    | **SD Card** (requires rebooting the Nintendo Switch into Hekate).
  - [NX-Shell](https://github.com/joel16/NX-Shell) (only for interacting with
    existing files)

### Pre-flight

1. On your computer, download and extract the most recent release from GitHub.
1. Open a terminal window and navigate to the extracted folder from step 1.
   - e.g. `cd "~/Downloads/KotOR II Switch modding"`
1. Run the following command to initialize the folder structure:
   ```bash
   ./bin/initialize
   ```
   - This will create a folder named `0100B2C016252000`, which is the title ID
     of the game on Switch.
1. On the Nintendo Switch, do the following in the nxdumptool app:
   - Navigate to **Dump installed SD card /eMMC content** | **Star Wars™️ -
     Knights of the Old Republic™️ II** | **RomFS options**.
   - Change the **Use update/DLC** option to the installed game update.
   - Select **Browse RomFS section**.
   - Dump the following files:
     - `./swplayer.ini`
     - `./Localized/<language>/dialog.tlk`
   - Transfer these files from `/atmosphere/contents/0100B2C016252000` on the
     Nintendo Switch to your computer using a file transfer option of your
     choice (common options listed above in the `Prerequisites` section).
   - Place both transferred files into the `0100B2C016252000/romfs` folder.
     - Make sure to place the `dialog.tlk` directly in the above folder, not
       `Localized/<language>`.

### Mod installation

1. Start installing mods like usual. General notes:
   - Linking the `0100B2C016252000/romfs` folder to the desktop is very
     useful for TSLPatcher that some mods use, which always defaults to the
     desktop, e.g. `ln -s "$(pwd)/0100B2C016252000/romfs" ~/Desktop/romfs`.
   - When using mods that use TSLPatcher, make sure to pay attention to the
     installation logs — warnings are common and not usually anything to worry
     about, but errors can occur due to missing files that the mod installer
     expects (known mods listed below). If this occurs:
     - In the TSLPatcher window, make a note of the filepath associated with
       the error (e.g. `lips/003EBO_loc.mod`.
     - Dump the file from your Nintendo Switch
       - You may need to look under `Localized/<language>` due to how the
         Nintendo Switch version of the game implemented other languages).
     - Transfer the dumped file to your computer and place it in the location
       that the mod installer expected in `0100B2C016252000/romfs`.
     - Re-run the TSLPatcher installer.
1. Recommended, but not required: periodically archive currently installed mods
   between mod installations with the following command:
   ```bash
   ./bin/archive "recommended-optional-description"
   ```
   - At any point, you can restore an archive with the following command:
     ```bash
     ./bin/restore
     ```

### Wrapping up

1. Once all desired mods have been installed, run the following command:
   ```bash
   ./bin/finalize
   ```
   - To undo finalization (e.g. for further adjustments), run the following
     command to restore a backup that was automatically created by the
     finalization script:
     ```bash
     ./bin/restore 0
     ```
   - **Make sure to pay attention to any warnings that appear.**
     - The most common warning will be texture files that aren't in the `.tpc`
       format when the Nintendo Switch version of the game already has the same
       texture in that format. These Nintendo Switch `.tpc` files will always
       override any `.tga` or `.dds` texture files — the solution is to convert
       these files to `.tpc` where possible (e.g. using
       [tga2tpc 4.0.0](https://deadlystream.com/files/file/1152-tga2tpc/)).
1. On the Nintendo Switch, delete the `/atmosphere/contents/0100B2C016252000`
   folder, if it exists.
1. Copy the `0100B2C016252000` folder from your computer to the
   `/atmosphere/contents` folder on your Nintendo Switch's SD card.
   - **NOTE**: network-based file transfers (e.g. FTP) will work with no
     issues, but for larger mod packs, you may want to use the Hekate option
     mentioned above for faster and more reliable transfers.

## Known mods that require additional dumped files

If you find any more of these, please feel free to create a GitHub issue or a
pull request.

- Extended Korriban arrival 1.2
  - `Lips\003EBO_loc.mod`
- Darth Sion and Male Exile Mod 1.2.3
  - `lips\702kor_loc.mod`
  - `lips\907mal_loc.mod`

## Contributing

Contributions are welcome via pull requests! Please follow the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
guidelines for commit messages.

## Usage in other mods

Feel free to reference this mod in any other projects. However, please note
that this project uses the GNU GPL v3 license. You can view a
[layman's terms breakdown](https://www.gnu.org/licenses/quick-guide-gplv3.en.html)
of the license, but the most important thing to note is that **any** projects
or distributions that modify or include code from this project must **also**
have their source code published and publicly available.

Please don't hesitate to contact me if this causes major issues for a mod
you're creating.
