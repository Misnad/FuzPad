# Notes Bash Script Powered by FZF

This repository contains a Bash script that helps manage notes with options to create, open, search, and delete notes.

![main_menu](https://i.imgur.com/5WXsOH1.png)

![open_note](https://i.imgur.com/lkyY8Fe)

![search_notes](https://i.imgur.com/NMbPXN7)

![delete_notes](https://i.imgur.com/5IljHKS)

## Features

- **New**: Create a new note with the current date and time as the filename.
- **Open**: Open an existing note using fuzzy finder (fzf).
- **Search**: Search within notes for specific content.
- **Delete**: Delete selected notes.
- **Quit**: Exit the script.

## Planned Features
- **Tags**: tagging system
- **Version control**: utilize git for syncing notes

## Goals

- Provide a straightforward note management solution using a Bash script.
- Ensure ease of use with intuitive commands and interface.

## Requirements

- Bash
- [fzf](https://github.com/junegunn/fzf) (fuzzy finder)
- [bat](https://github.com/sharkdp/bat) (for enhanced preview in search)
- Your preferred text editor (default is `nano`)

## Usage

1. Clone the repository:

```sh
git clone https://github.com/JianZcar/notes-bash.git
cd notes-bash
```

2. Make the script executable:

```sh
chmod +x bin/notes
```

3. Run the script:

```sh
./bin/notes
```

## Configuration

- **Default Directory**: Change the default directory for notes by modifying the `NOTES_DIR` variable in the script.
- **Text Editor**: Change the text editor by modifying the `EDITOR` variable in the script.
- **Text Format**: Change the text format by modifying the `TEXT_FORMAT` variable in the script.

## Contributing

Feel free to fork the repository and submit pull requests. Contributions are welcome!

## License

This project is licensed under the terms of the GNU General Public License v3.0. For more details, see the [LICENSE](LICENSE) file in the repository.
