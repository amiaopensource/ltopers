#LTOpers Documentation#
##Formatting LTO##

**LTO tapes need to be formatted before they can be used. Run the following command:**

`$mkltfs --device=$deck --tape-serial="$tapeid" --no-compression -r "size=5M/name= *txt:*.xml:*.jpg:*.log:*.json:*.framemd5:*.scc" --volume-name="$tapeid"`

(You can remove the --device part if you only have one deck. The -r parts are rules for what files can live in the index partition which gives faster access.)

**$tapeid is the identifier for the tape.  Name the tape like so:**

`Lxxxxx`

(where xxxxx is a 5-digit sequential number, e.g. L00001, L00002, etc.)

**Remember to physically label the tape with the tapeid!**

##Set Configuration##

If this is the first time you are running the LTO scripts, you must first edit the configuration file.

**Run ltoperconfig script.**

**Follow the prompts to edit the following variables:**
    
`FILEMAKER_USER=  XXXXX`
`FILEMAKER_PASS=   XXXXX`
`FILEMAKER_DB= XXXXX`
`FILEMAKER_XML_URL=xxx.xxx/xxx.xml`

##Mounting LTO & Creating XMLs##

**Put tape you want to mount in the deck (you do not have to push it in all the way).**

**Run the mountlto script to mount the tape.**

Script will check for attached tape drive, and will prompt for deck name if there are multiple drives.

**When prompted, enter the name of the tape to mount** (e.g. L00001).

Tape will load in deck and mount. 

**In Finder, go to Go > Go to Folder, and enter /Volumes/$tapeid to navigate to tape in Finder.**

**To unmount the tape, Ctrl-C in Terminal.**

Whenever a tape is ejected, the script will write the tape’s xml (a .schema file) to $HOME/Documents/lto_indexes. If a .schema file for that tape already exists, it will just update the existing schema file with any new data.

The mountlto script will then prompt the lto2filemaker script (see tools section below) to run.

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


