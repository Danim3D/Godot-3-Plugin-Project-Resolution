# ProjectResolution

Godot plugin to quickly change and test Project Resolution settings.


## Download

- Install from the Godot Asset Library (under review, link pending).
- or clone github repository at https://github.com/Danim3D/godot-plugin-project-resolution
- or download at https://danim3d.itch.io/godot-plugin-project-resolution


## Installation

- Copy the contents of the "addons" directory to the "addons" directory of your Godot Project
- Go in "Project - Project Settings - Plugins (tab)" and enable "ProjectResolution"


## Usage

Once the plugin is activated, a new button will show up on the Top-Right corner of the Godot Editor, above the Inspector tab.
On use, the name of the button "Project Resolution" will be renamed by the selected resolution.

- "Fullscreen" will toggle the Fullscreen setting from the Projects Settings.
- "Play on Change" will play your main project scene when you change the resolution with the plugin.
- "Multistart" will play two instances side by side centered on the screen, this is useful for networking testing. This option will disable Fullscreen settings on play. Note with this option you can't use the stop button and will have to close each window instance.
- "Native" will use the current resolution of your desktop.
- Custom resolutions can be added in the list of resolutions inside the plugin.gd file.
