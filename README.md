# SudoLauncher

**SudoLauncher** is a game launcher & library manager supporting any locally installed executables. 

## Installation

Once downloaded, place SudoLauncher.exe in a directory on it's own, and run it. 
The first time it is run, it will create three folders by default:

- **data** - contains metadata files for the games SudoLauncher can launch, as well as the tags and directories files
- **games** - an optional folder that can be used to install games into.
- **icons** - an optional folder that can be used to store library icons.

By default, these subfolders will be empty. The **data** folder will automatically populate with metadata files as games are added.

## Library

The library screen is divided into two sections, on the left is the **Library** and on the right is the **Details Panel**.

At the top of the **Library** section sits the **Top Bar**, containing filtering, sorting, and display controls for the **Library List**. The **Search bar** will filter the list based on the entered search term. The **Tag list** filters the list based off of the tags selected from the list, the filter will only display games that match **all** selected tags. Tag filtering and search filtering can be combined.

By default, the **Library List** will be empty. It will populate after one or more directories are added (see below).

On the right of the library is the **Details Panel**, displaying information about the currently selected game. The **Details Panel** also contains the **Play Button** and access to metadata editing.

The size of the **Library** & **Details Panel** can be adjusted by dragging the divider in the middle of the two.

## Managing directories

Directories can be added in the **Settings** tab. In the directories section, click the **Add** button, and select the folder you wish to add.

To remove a library directory, select the directory(s) from the list, and click the **Remove** button.

Finally, ensure you click the **Scan Directories** button to initialize the library from the set directories. This will populate the **library** folder with metadata files for the game(s) detected in the set directories, and remove from the library any games in removed directories.

## Editing game information
The display information for each game can be edited in the window that opens after pressing the **Edit Details** button in the bottom right of the **Details Panel**.
Here, the following properties can be viewed and/or edited for each game:
- **name** - the game's title.
- **path** - the file path for the game's executable or shortcut. 
- **icon** - the file path for the game's icon file.
- **year** - the year the game was originally released in. Used for sorting and filtering in the library. Must be set manually, by default will be blank (set to 0).
- **developer** - the name of the developer that created the game. Used for sorting and filtering in the library. Must be set manually, by default will be blank.
- **tags** - a list of tags assigned to the game.
- **args** - a string of launch arguments

> **Note:** The **name** and **path** properties will be automatically assigned using the name of the executable.

> **Note:** Game information can also be manually edited by opening the metadata files in a text editor, though this is not recommended.

# Credits
Created using ***Godot***.

*Godot Icons Fonts* & *Rakugo Nodes* by **Jeremi Biernacki**, licensed under the MIT License.

License files can be found in the relevant directories.

## Testers
Aidan Stevens
Vasaesia
Ellie/Lirie
Ziffel
And0ch/Scaralus

# License
SudoLauncher © 2025 by Toby Lofas is licensed under CC BY-NC 4.0. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc/4.0/
