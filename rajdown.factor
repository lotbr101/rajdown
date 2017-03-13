USING: kernel http.client html.parser sequences assocs accessors command-line namespaces
io.directories io.files.types io.pathnames sets vectors progress-bars math ;

IN: rajdown

TUPLE: progress count total percent ;


: <progress> ( count total -- progress ) 0 progress boa ;

: progressStep ( seq progress -- progress seq ) swap [ count>> ] keep swap 1 + swap [ count<< ] keep ;

: initProgress ( seq -- progress seq ) [ length ] keep swap 0 swap <progress> swap ;

: setPercent ( progress -- progress )  [ count>> ] keep [ total>> ] keep [ / ] dip [ percent<< ] keep ;

: drawProgressBar ( progress -- progress ) [ percent>> ] keep swap 90 make-progress-bar print ;

: isPhotoThumb ( elt -- ? ) "class" swap at "photoThumb" = ;

: isLink ( elt -- ? ) name>> "a" = ;

: downPage ( str -- seq ) http-get nip parse-html ;

: getLinks ( seq -- seq ) [ isLink ] filter ;

: getPhotoLinks ( seq -- seq ) [ attributes>> isPhotoThumb ] filter ;

: getPhotoAddresses ( seq -- seq ) [ attributes>> "href" swap at ] map ;

: processAddresses ( seq -- ) [ download ] each ;

: getDirectoryFiles (  -- seq ) "." directory-entries [ type>> +regular-file+ = ] filter ;

: getDirectoryFileNames ( seq -- seq ) [ name>> ] map ;

: getPhotoUrlDirectory ( seq -- seq string ) dup first parent-directory ;

: prependUrlToFiles ( url seq -- seq ) [ append ] with map ;

: createLocalDirectoryVector ( url -- seq ) getDirectoryFiles getDirectoryFileNames prependUrlToFiles >vector ;

: createRemoteDirectoryVector ( url -- seq ) downPage getLinks getPhotoLinks getPhotoAddresses ;
    
: processUrl ( url -- ) createRemoteDirectoryVector  getPhotoUrlDirectory createLocalDirectoryVector
    diff
    processAddresses ;

: get-run ( -- ) command-line get first processUrl ;

MAIN: get-run
