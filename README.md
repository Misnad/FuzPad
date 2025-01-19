# Notes

 _A note management bash script. Powered by [junegunn/fzf](https://github.com/junegunn/fzf)_

<img src="https://i.imgur.com/5WXsOH1.png" alt="Sample Image" width="500"/>
<img src="https://i.imgur.com/lkyY8Fe.png" alt="Sample Image" width="500"/>
<img src="https://i.imgur.com/NMbPXN7.png" alt="Sample Image" width="500"/>
<img src="https://i.imgur.com/5IljHKS.png" alt="Sample Image" width="500"/>

## Features

- **New**: Create a new note with the current date and time as the filename.
- **Open**: Open an existing note.
- **Search**: Search within notes for specific content.
- **Delete**: Delete selected notes.

## Planned Features
- **Tags**: tagging system
- **Version control**: utilize git for syncing notes
- **Make an installer**: use brew for packaging
- **CLI**: create a cli that allows piping, etc.

## Goals

- Provide a straightforward note management solution using a Bash script.
- Ensure ease of use with intuitive commands and interface.

## Requirements

- Bash
- [fzf](https://github.com/junegunn/fzf) (fuzzy finder)
- [bat](https://github.com/sharkdp/bat) (for enhanced preview)
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
