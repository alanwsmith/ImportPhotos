# import-photos

A perl script to import your photos. 

## TODO

- Add support for iPhone 4 photos
- Add support for iPhone 5 photos
- Add support for iPhone 6 photos
- Add support for iPhone 7 photos


## Deployment

The current deployment is to simply copy the ImportPhotos file to:

    /usr/local/bin/ImportPhotos

and then make sure it's setup to be executable. It's all self contained (though it does point to the config file listed below).



## Config

The config for the script id defined by the ~/Library/ImportPhotos/ImportPhotos.ini file. 


## Testing

Make sure this file exists:

    do-not-run.txt


Testing is done by running this command in the project directory:

    prove

Verbose output is produced with:
  
    prove -v


