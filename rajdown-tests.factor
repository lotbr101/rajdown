USING: kernel tools.test html.parser rajdown rajdown.private ;

IN: rajdown.tests

{ t }
[ { { "class" "photoThumb" } } isPhotoThumb  ] unit-test

{ t }
[ "a" "aaa" "test" f tag boa isLink ] unit-test


