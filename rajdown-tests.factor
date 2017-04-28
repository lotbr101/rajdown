USING: kernel tools.test html.parser rajdown rajdown.private ;

IN: rajdown.tests

{ t }
[ { { "class" "photoThumb" } } isPhotoThumb  ] unit-test

{ t }
[ "a" { { "class" "photoThumb" "href" "http://www.test.co.uk/test.jpg"} } "test image" f  tag boa isLink ] unit-test


