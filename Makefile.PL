use ExtUtils::MakeMaker;

WriteMakefile(
	NAME      => 'Crypt::Mimetic',
	VERSION_FROM => 'lib/Crypt/Mimetic.pm',
	AUTHOR    => 'Erich Roncarolo, erich-roncarolo@users.sourceforge.net',
	ABSTRACT  => 'Camouflage a file behind another one',
	EXE_FILES => [ glob "bin/*" ],
	dist      => {COMPRESS=>'gzip -9f', SUFFIX => 'gz'},
);
