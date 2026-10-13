# Project Workspace Initializer

A small Bash utility that creates a practical, language-agnostic directory
structure for a new project.

## Requirements

- Bash
- A Unix-like environment (Linux, macOS, or WSL)

## Usage

```bash
./auto-folder [project-directory]
```

If no directory is supplied, the folders are created in the current directory.
The target directory is created if it does not already exist. Existing
directories are left in place.

```bash
# Show usage
./auto-folder --help

# Create the folders in the current directory
./auto-folder

# Create a new project directory
./auto-folder my-project
```

You can also run the script with Bash without making it executable:

```bash
bash ./auto-folder my-project
```

## Folders created

```text
project-directory/
├── .github/
│   └── workflows/
├── assets/
│   ├── data/
│   └── images/
├── build/
├── config/
├── docs/
├── scripts/
├── src/
└── tests/
```

The script accepts at most one project-directory argument. It exits with an
error if the target already exists as a non-directory path.

## Tests

Run the test suite with Bash:

```bash
bash tests/auto-folder.bash
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
