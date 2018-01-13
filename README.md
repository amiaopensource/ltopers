# LTOpers Documentation

This documentation is up to date as of LTOpers version 2018-01-13.

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

To install the general LTO-handling tools, run the following command:

```
brew install amiaopensource/amiaos/ltopers
```

To install the general LTO-handling and the database-specific tools, run the following command:

```
brew install amiaopensource/amiaos/ltopers --with-db
```

To install the general LTO-handling, the database-specific and the CUNY-specific tools, run the following command:

```
brew install amiaopensource/amiaos/ltopers --with-cuny
```

To update LTOpers tools, run the following commands:

```
brew update
brew upgrade
```

#### Note

This will update Homebrew and upgrade every package you've installed using it.

## Formatting LTO

LTO tapes need to be formatted before they can be used. Run the following command:

```
formatlto
```

The script will ask you select a deck (if you have more than one attached) and to name your tape. There are two different tape ID formats:

- the 6-char ID must be exactly 6 capital letters and/or numbers
- the 8-char ID must be exactly 6 capital letters and/or numbers, followed by 'L5', 'L6' or 'L7' specifying the LTO generation.

Examples:

- Annnnn
- BnnnnnL6

where nnnnn is a 5-digit sequential number, e.g. A00001, A00002, etc. or respectively B00001L6, B00002L6, etc.

The script will format your tape in LTFS format, with no compression, and sets rules that allow smaller types of files to live in the index partition of the tape, which gives you faster access. If you need to change this, edit the mkltfs line in the script to suit your preferences.

**Remember to physically label the tape with the tape ID!**

## Mounting LTO

Put the tape you want to mount in the deck (you do not have to push it in all the way).

To mount the tape run the following command:

```
mountlto
```

The script will check for attached tape drive, and will prompt for deck name if there are multiple drives.

The tape will load in deck and mount.

In Finder, go to Go > Go to Folder, and enter /Volumes/$tapeid to navigate to tape in Finder.

## Un-mounting LTO and creating XML

To unmount the tape, Ctrl-C in Terminal.

Whenever a tape is ejected, the script will export the tape’s index (as an XML .schema file) to the path set as `LTO_INDEX_DIR` in `mmconfig`. To set or change the path, type `mmconfig` to access the configuration GUI. If there is no path set, the index location will default to `$HOME/Documents/lto_indexes`. If a .schema file for that tape already exists in that location, it will just update the existing schema file with any new data.

## Writing to LTO

To write data onto a tape, run the following command:

```
writelto
```

When prompted, enter the tape ID and the source directory.

The script will run rsync twice the transfer the data to the LTO tape. It runs twice to address an unresolved problem with small-sized files not transferring properly (running it twice seems to fix the errors).

To read back and create checksums for the contents of a tape, and write checksums to a file named with the tape name and date, run the following command:

```
writelto -v
```

The checksum file will be written to the LTO logs directory: `LTO_INDEX_DIR` (also set in `mmconfig`) or `$HOME/Documents/lto_indexes` (default if not set in mmconfig).

This command uses the tool `md5deep`, which has [several flags to set options](http://md5deep.sourceforge.net/md5deep.html). To customize which flags you want to append to `md5deep`, set the variable `LTO_MD5_FLAGS` in `mmconfig` (type `mmconfig` to access the configuration GUI). 

## Database integration

LTOpers can integrate with the database reporting functions in [mediamicroservices](https://github.com/mediamicroservices/mm). For information on how to set up the database see the mediamicroservices' [readme](https://github.com/mediamicroservices/mm#database-instructions).

If the database is activated and configured LTOpers will store information from LTO schema files, fixity information and PREMIS event information relating to LTOpers and microservices.

Database-specific tools in LTOpers are `searchlto`, `ingestschemas` and `ingestcollectionchecksum`. Both `ingestchemas` and `ingestcollectionchecksum` are designed for importing already existing information to the database (LTO schema information and read back checksums respectively). They can be run either on individual files or on directories containing multiple files.

`searchlto` is for performing searches against the LTO schema information stored in the database. It accepts either a media ID or an LTO ID as an input and will return a list of matching service files. Options are `-h` display help, `-c` compare characteristics of an input file to records in the database, and `-f` show full results (this will show all matches to search term as opposed filtering for service files only).

## License

LTOpers is licensed under an <a href="https://github.com/amiaopensource/ltopers/blob/master/LICENSE">MIT License</a>.

