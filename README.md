# ImportPhotos

This is the archive of the perl script I used
for the past decade to import photos from
my various cameras.

## Overview


At the high level it:

-   copies images from a source directory to
    a destination folder

-   Uses metadata in the images to create
    a base filename from the datetime stamp
    of the image in the format that goes
    down to the second

-   Adds a "conflict number" to the file
    names that increments every time the
    current image has the same timestamp
    as an existing

-   Adds a verion letter to the filename

-   An example of the full filename looks
    like:

        aws-20191111--1738-01a.cr2

-   The script also does a hash of the
    source and destination files to make
    sure the copy wasn't corruppted
    (something that used to be a problem
    with usb drives)

## Documentation

I don't really remember how the code
works and it's Perl which I haven't
written in years. But, I'm very
pleased with the documentation in the
file.

I hear all the time that the code
should be the documentation and
I still think that's good advice,
but I never thought about it from
the perspective of looking at code
that's in a language you're not familiare
with. And, even with that, it's way
faster to parse the text than figure
out the code.

Long story short, expect to see way
more docstrings outta me.

## Age

I'm not kidding about having used this 
for a decade. The first test files
are from 2012

I'm also pretty sure this was an overhaul
of an earlier version when I moved it 
to Moose for an Object Oriented framework

## Old Notes

Here's the orignal notes that were in this
README which I find amusing becase they
talk about adding support for the iPhone
4. 

---


A perl script to import your photos.

### TODO

-   Add support for iPhone 4 photos
-   Add support for iPhone 5 photos
-   Add support for iPhone 6 photos
-   Add support for iPhone 7 photos

### Deployment

The current deployment is to simply copy the ImportPhotos file to:

    /usr/local/bin/ImportPhotos

and then make sure it's setup to be executable. It's all self contained (though it does point to the config file listed below).

### Config

The config for the script id defined by the ~/Library/ImportPhotos/ImportPhotos.ini file.

### Testing

Make sure this file exists:

    do-not-run.txt

Testing is done by running this command in the project directory:

    prove

Verbose output is produced with:

    prove -v
