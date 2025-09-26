# SudoLauncher

**SudoLauncher** is a game launcher & library manager supporting any locally installed executables. 

## Installation

Once downloaded, place SudoLauncher.exe in a directory on it's own, and run it. 
The first time it is run, it will create three folders by default:

- **data** - contains metadeta files for the games SudoLauncher can launch, as well as the tags and directories files
- **games** - an optional folder that can be used to install games into.
- **icons** - an optional folder that can be used to library icons.

By default, these subfolders will be empty. The **data** folder will automatically populate with metadeta files as games are added.

## Library

The library screen is divided into two sections, on the right is the **Library** and on the left is the **Details Panel**.

At the top of the **Library** section sits the **Top Bar**, containing filtering, sorting, and display controls for the **Library List**. The **Search bar** will filter the list based off the entered search term. The **Tag list** filters the list based off of the tags selected from the list, the filter will only display games that match **all** selected tags. Tag filtering and search filtering can be combined.

By default, the **Library List** will be empty. It will populate after one or more library folders are added (see below).  The display of icons in the **Library List** can be toggled on and off with the button on the far-right of the **Top Bar**. **SudoLauncher** does **not** use the internet in any capacity, and so library assets such as game icons must be provided by the user.

On the right of the library is the **Details Panel**, displaying information about the currently selected title. The **Details Panel** also contains the **Play Button** and access to metadata editing.

The size of the **Library** & **Details Panel** can be adjusted by dragging the divider in the middle of the two.


## Managing library folders

Library folders can be added in the **Settings** tab. In the library directories section, click the **Add** button, and select the folder you wish to add.

To remove a library folder, select a directory from the list, and click the **Remove** button.

Finally, ensure you click the **(Re)Build** button to initialize the library from the set directories. This will populate the **library** folder with metadata files for the game(s) detected in the set directories.

## Metadata files

To display and store information about the games in the library, **SudoLauncher** uses metadata files. The metadata files store the following properties for each game:
- **name** - the game's title.
- **path** - the file path for the game's executable.
- **icon** - the file path for the game's icon file.
- **year** - the year the game was originally released in. Used for sorting and filtering in the library. Must be set manually, by default will be blank.
- **developer** - the name of the developer that created the game. Used for sorting and filtering in the library. Must be set manually, by default will be blank.
- **tags** - a list of strings that representing the assigned categories for the game.

> **Note:** The **name** and **path** properties will be automatically assigned using the name of each executable found. If you have added a library directory that contains subfolders for each game, and those games have multiple executables in the subfolder (e.g. a level editor), you will need to ensure unwanted executables are deleted from the library.

The metadata for games can be edited within **SudoLauncher** itself, using the edit window opened by clicking the edit button in the bottom-right corner of the **Details Panel**.

Metadata files can also be manually edited by opening the file in a text editor.

# Credits
Created using ***Godot 4.3***.

*Godot Git Plugin* by **The Godot Engine community**, licensed under the MIT License.

*Godot Icons Fonts* & *Rakugo Nodes* by **Jeremi Biernacki**, licensed under the MIT License.

*Native Dialogues* by **Tomás Espejo Gómez**, licensed under the MIT License.


License files can be found in the relevant directories.
