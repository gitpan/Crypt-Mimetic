#!perl

use Crypt::Mimetic;

use Error;
$Error::Debug = 1;

print "\nPerforming tests for Crypt::Mimetic\n";
print "Looking for available encryption algorithms, please wait... ";
select((select(STDOUT), $| = 1)[0]); #flush stdout
@algo = Crypt::Mimetic::GetEncryptionAlgorithms();
print @algo ." algorithms found.\n\n";
$str = "This is a test string";
$failed = 0;
foreach my $algo (@algo) {
	print ''. Crypt::Mimetic::ShortDescr($algo) ."\n";
	print " Encrypting string '$str' with $algo...";
	select((select(STDOUT), $| = 1)[0]); #flush stdout
	($enc,@info) = Crypt::Mimetic::EncryptString($str,$algo,"my stupid password");
	print " done.\n";
	print " Decrypting encrypted string with $algo...";
	select((select(STDOUT), $| = 1)[0]);
	$dec = Crypt::Mimetic::DecryptString($enc,$algo,"my stupid password",@info);
	print " '$dec'.\n";
	if ($dec eq $str) {
		print "Algorithm $algo: ok.\n\n";
	} else {
		print "Algorithm $algo: failed. Decrypted string '$dec' not equals to original string '$str'\n\n";
		$failed++;
	}
}
print @algo ." tests performed: ". (@algo - $failed) ." passed, $failed failed.\n\n";
exit $failed;
