# archive

A [POSIX](https://en.wikipedia.org/wiki/POSIX)-compliant Unix shell script which adds archiving functionality to your directories. Archiving in this context refers to archiving as found in email clients, etc.

## Motivation

Email clients and productivity software (e.g. to-do list or note taking applications) usually offer an 'archive' feature, which users can use to move items which are not relevant anymore to a separate area to reduce cluttering. This way, the user can focus on items which are relevant right now, while still keeping old items for reference. This script aims to add this functionality to Unix-like systems.

## How does it work?

It is essentially a specialised interface to the tool `tar`. Instead of the user having to worry about remembering and typing long tar commands, handling errors, keeping track of tar files, etc. this script abstracts away all that to make archiving as simple as archiving an email with the click of a button: `archive -a file.txt`.

## Installation

Clone repository

```sh
git clone https://github.com/ilkutkutlar/archive.git
```

then run the `install.sh` script in project root directory. It will install files in `/usr/local` by default, but you can specify another directory as well - just make sure the `bin` directory in custom install directory is in your PATH.

```sh
cd archive

# Install in default /usr/local
sudo sh install.sh

# Install in custom directory
sudo sh install.sh /usr
```

## Basic usage

Each directory has its own archive file (called `.archive.tar`) that's created when first file is archived. That's where all archived files are stored. Add file to CWD's archive (without removing file):

```sh
archive -a file.txt
```

To move file to archive (add to archive, remove it afterwards):

```sh
archive -a file.txt -d
```

To archive a gzipped version of the file (gzip the file, add gzipped version to archive, remove the gzipped file but keep the original unchanged):

```sh
archive -z file.txt
```

Pass the `-d` flag to remove the original, un-gzipped file after adding the gzipped version to archive:

```sh
# Gzip the file to file.txt.gz, add file.txt.gz to archive,
# then remove 'file.txt.gz' and remove 'file.txt' as well.
archive -z file.txt -d
```

To unarchive file (but still keep in archive):

```sh
archive -u file.txt
```

To unarchive file and remove from archive:

```sh
archive -u file.txt -d
```

To list archive contents:

```sh
archive -l
```

## Options

```sh
-a, --add FILE          # Add file to archive of current directory
-u, --unarchive FILE    # Unarchive file from archive of current directory
-d, --delete            # Pass flag to -a, -u or -z to delete file in dir/archive after operation
-z, --add-gzipped FILE  # Add a gzipped version of file to archive. Original file is not affected unless -d is passed
-l, --list              # List the files in current directory archive
-t, --top-level         # List only top-level files and directories in current directory archive
-v, --version           # Print version and exit
-h, --help              # Print help and exit
```

## Development

- Script itself is written in POSIX-compliant shell (It works at least with [Dash](https://en.wikipedia.org/wiki/Almquist_shell#dash), a very minimalistic shell that has very little to no extra features beyond what POSIX standard specifies).
- The tests are written in [Bats](https://github.com/bats-core/bats-core) >= v1.2.1. Even though it is generally meant for Bash scripts, since Dash/POSIX shell is a subset of Bash, it can still be used for this project.
- [ShellCheck](https://github.com/koalaman/shellcheck) >= v0.7.1 is used to check for best-practices.
- You can run all tests and ShellCheck together by using the `run_tests` script:

```sh
sh test/run_tests
```

