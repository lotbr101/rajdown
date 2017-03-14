USING: kernel http.client html.parser sequences assocs accessors command-line namespaces
io.directories io.files.types io.files.info io.pathnames sets vectors progress-bars math io formatting ;

IN: rajdown

! progress bar handling
TUPLE: progress count total percent ;

: <progress> ( count total -- progress ) 0 progress boa ;

: progressStep ( progress -- progress ) [ count>> ] keep [ 1 + ] dip [ count<< ] keep ;

: initProgress ( seq -- seq progress ) [ length ] keep swap 0 swap <progress> ;

: setPercent ( progress -- progress ) [ [ count>> ] [ total>> ] bi ] keep [ / ] dip [ percent<< ] keep ;

: drawProgressBar ( progress -- progress ) [ percent>> ] keep swap 60 make-progress-bar "%s\r" printf ;

: doProgressBar ( progress -- progress ) progressStep setPercent drawProgressBar ;

! web part
: isPhotoThumb ( elt -- ? ) "class" swap at "photoThumb" = ;

: isLink ( elt -- ? ) name>> "a" = ;

: downPage ( str -- seq ) http-get nip parse-html ;

: getLinks ( seq -- seq ) [ isLink ] filter ;

: getPhotoLinks ( seq -- seq ) [ attributes>> isPhotoThumb ] filter ;

: getPhotoAddresses ( seq -- seq ) [ attributes>> "href" swap at ] map ;

: processAddresses ( seq -- ) initProgress drawProgressBar swap [ download doProgressBar ] each drop ;

! local directory part
: getDirectoryFiles (  -- seq ) "." directory-entries [ regular-file? ] filter ;

: getDirectoryFileNames ( seq -- seq ) [ name>> ] map ;

: getPhotoUrlDirectory ( seq -- seq string ) dup first parent-directory ;

: prependUrlToFiles ( url seq -- seq ) [ append ] with map ;

: createLocalDirectoryVector ( url -- seq ) getDirectoryFiles getDirectoryFileNames prependUrlToFiles >vector ;

: createRemoteDirectoryVector ( url -- seq ) downPage getLinks getPhotoLinks getPhotoAddresses ;

! working word
: processUrl ( url -- ) createRemoteDirectoryVector  getPhotoUrlDirectory createLocalDirectoryVector
    diff
    processAddresses ;

: get-run ( -- ) command-line get first processUrl ;

MAIN: get-run
