# LTOpers Documentation

This documentation is up to date as of LTOpers version 2019-01-18.

## LTOpers elements

### General LTO-handling tools

- formatlto
- mountlto
- readlto
- renameschemas
- verifylto
- writelto

### Database-specific tools

- ingestcollectionchecksum
- ingestschemas
- searchlto

### CUNY-specific tool

- collectionchecksum
- indexschemas

## Installing LTOpers

You can easily install these tools using Homebrew. To install Homebrew, follow the [instructions](http://brew.sh/).

Install the LTFS utilities. Please use version 2.2 on the [Quantum site](http://www.quantum.com/serviceandsupport/softwareanddocumentationdownloads/ltfs/index.aspx?whattab=Third).

To install the general LTO-handling tools, run the following two commands:

```
brew tap amiaopensource
brew install ltopers
```

To install the general LTO-handling and the database-specific tools, run the following two commands:

```
brew tap amiaopensource/amiaos
brew install ltopers --with-db
```

To install the general LTO-handling, the database-specific and the CUNY-specific tools, run the following two commands:

```
brew tap amiaopensource/amiaos
brew install ltopers --with-cuny
```

To update LTOpers tools, run the following commands:

```
brew update
brew upgrade
```

#### Note

This will update Homebrew and upgrade every package you've installed using it.

By default, LTOpers scripts use the standard tape serials, consisting of 6 character strings of numbers and capital letters. (However, the flag `-x` allows to use the barcode label as tape serial for non-standard implementations.)

## Formatting LTO

LTO tapes need to be formatted before they can be used. Run the following command:

```
formatlto
```

The script will ask you select a deck (if you have more than one attached) and to provide a tape serial your tape. The tape serial format is exactly 6 capital letters and/or numbers.

Example:

- Annnnn

where nnnnn is a 5-digit sequential number, e.g. A00001, A00002, etc.

The script will format your tape in LTFS format, with no compression, and sets rules that allow smaller types of files to live in the index partition of the tape, which gives you faster access. If you need to change this, edit the mkltfs line in the script to suit your preferences.

**Remember to physically label the tape with the tape serial!**

## Mounting LTO

Put the tape you want to mount in the deck (you do not have to push it in all the way).

To mount the tape run the following command:

```
mountlto
```

The script will check for attached tape drive, and will prompt for deck name if there are multiple drives.

The tape will load in deck and mount.

In Finder, go to Go > Go to Folder, and enter /Volumes/$tape_serial to navigate to tape in Finder.

## Un-mounting LTO and creating XML

To unmount the tape, Ctrl-C in Terminal.

Whenever a tape is ejected, the script will export the tape’s index (as an XML .schema file) to the path set as `LTO_INDEX_DIR` in `mmconfig`. To set or change the path, type `mmconfig` to access the configuration GUI. If there is no path set, the index location will default to `$HOME/Documents/lto_indexes`. If a .schema file for that tape already exists in that location, it will just update the existing schema file with any new data.

## Writing to LTO

To write data onto a tape, run the following command:

```
writelto
```

When prompted, enter the tape serial and the source directory.

The script will run `gcp` to transfer the data to the LTO tape (`rsync` is used as a backup check for `gcp`).

To read back and create checksums for the contents of a tape, and write checksums to a file named with the tape serial and date, run the following command:

```
writelto -v
```

The checksum file will be written to the LTO logs directory: `LTO_INDEX_DIR` (also set in `mmconfig`) or `$HOME/Documents/lto_indexes` (default if not set in mmconfig).

This command uses the tool `md5deep`, which has [several flags to set options](http://md5deep.sourceforge.net/md5deep.html). To customize which flags you want to append to `md5deep`, set the variable `LTO_MD5_FLAGS` in `mmconfig` (type `mmconfig` to access the configuration GUI). 

## Database integration

LTOpers can integrate with the database reporting functions in [mediamicroservices](https://github.com/mediamicroservices/mm). For information on how to set up the database see the mediamicroservices' [readme](https://github.com/mediamicroservices/mm#database-instructions).

If the database is activated and configured LTOpers will store information from LTO schema files, fixity information and PREMIS event information relating to LTOpers and microservices.

Database-specific tools in LTOpers are `searchlto`, `ingestschemas` and `ingestcollectionchecksum`. Both `ingestchemas` and `ingestcollectionchecksum` are designed for importing already existing information to the database (LTO schema information and read back checksums respectively). They can be run either on individual files or on directories containing multiple files.

`searchlto` is for performing searches against the LTO schema information stored in the database. It accepts either a media ID or an LTO tape serial as an input and will return a list of matching service files. Options are `-h` display help, `-c` compare characteristics of an input file to records in the database, and `-f` show full results (this will show all matches to search term as opposed filtering for service files only).

## License

LTOpers is licensed under an <a href="https://github.com/amiaopensource/ltopers/blob/master/LICENSE">MIT License</a>.

