#LTOpers Documentation#

##Installing LTOpers tools##
You can easily install these tools using Homebrew. To install Homebrew, follow the [instructions](http://brew.sh/).

Install the LTFS utilities. Please use version 2.2 on the [Quantum site](http://www.quantum.com/serviceandsupport/softwareanddocumentationdownloads/ltfs/index.aspx?whattab=Third).

To install LTOpers tools, run the following commands:

`brew tap amiaopensource/amiaos`

(this taps the homebrew recipes of the amiaopensource account)

`brew install ltopers`

(current version is 0.1.5)

If it ever updates you can update via:

```
brew update
brew upgrade
```

(nb: this will update/upgrade every package you've installed using brew)

##Formatting LTO##

**LTO tapes need to be formatted before they can be used. Run the formatlto script.**

**The script will ask you select a deck (if you have more than one attached) and to name your tape. There are two different tape ID formats:
- the 6-char ID must be exactly 6 capital letters and/or numbers
- the 8-char ID must be exactly 6 capital letters and/or numbers, followed by 'L5', 'L6' or 'L7' specifying the LTO generation.**

Examples:

```
Axxxxx
BxxxxxL6
```

where xxxxx is a 5-digit sequential number, e.g. A00001, A00002, etc. respectively B00001L6, B00002L6, etc.

The script will format your tape in LTFS format, with no compression, and sets rules that allow smaller types of files to live in the index partition of the tape, which gives you faster access. If you need to change this, edit the mkltfs line in the script to suit your preferences.

**Remember to physically label the tape with the tape id!**

##Set Configuration##

If this is the first time you are running the LTO scripts, you must first edit the configuration file.

**Run ltoperconfig script.**

**Follow the prompts to edit the following variables:**

```
FILEMAKER_USER=  XXXXX
FILEMAKER_PASS=   XXXXX
FILEMAKER_DB= XXXXX
FILEMAKER_XML_URL=xxx.xxx/xxx.xml`
```

##Mounting LTO & Creating XMLs##

**Put tape you want to mount in the deck (you do not have to push it in all the way).**

**Run the mountlto script to mount the tape.**

Script will check for attached tape drive, and will prompt for deck name if there are multiple drives.

**When prompted, enter the name of the tape to mount** (e.g. A00001 or B00001L6).

Tape will load in deck and mount. 

**In Finder, go to Go > Go to Folder, and enter /Volumes/$tapeid to navigate to tape in Finder.**

**To unmount the tape, Ctrl-C in Terminal.**

Whenever a tape is ejected, the script will export the tape’s index (as an xml .schema file) to $HOME/Documents/lto_indexes on your computer. If a .schema file for that tape already exists in that location, it will just update the existing schema file with any new data.

The mountlto script will then prompt the lto2filemaker script to run.

##Writing LTO##

**To write data onto a tape, run the writelto script.**

**When prompted, enter the tapeid and the source directory.**

The script will run rsync twice the transfer the data to the LTO tape. It runs twice to address an unresolved problem with small-sized files not transferring properly (running it twice seems to fix the errors).


##Writing LTO metadata to FileMaker##

This process happens automatically via the lto2filemaker script, which runs when the user unmounts the LTO tape using the mountlto script.  Using XML Starlet, the lto2filemaker script parses the xml documents and sends the metadata to the lto\_tapes and lto\_files tables in FileMaker.

Lto2filemaker can also be invoked independently:

`$lto2filemaker yourfile.schema`

##Tools##
*mountlto

*writelto

*ltoperconfig

*lto2filemaker (requires XMLStarlet)

##External locations of LTO scripts and related tools:##
https://github.com/amiaopensource/ltopers

http://xmlstar.sourceforge.net/


