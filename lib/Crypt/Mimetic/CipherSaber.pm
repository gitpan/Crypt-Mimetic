package Crypt::Mimetic::CipherSaber;
use strict;
use Error::Mimetic;
use vars qw($VERSION);
$VERSION = '0.01';

eval 'use Crypt::CipherSaber';
die ("Crypt::CipherSaber required by ". __PACKAGE__) if $@;

#
# string ShortDescr()
#
sub ShortDescr {
	return "CipherSaber - CipherSaber encryption algorithm.";
}

#
# boolean PasswdNeeded()
#
sub PasswdNeeded {
	return 1;
}

#
# (int,int,int,[string]) EncryptFile($filename,$output,$algorithm,$key,@info)
#
sub EncryptFile {
	my ($filename,$output,$algorithm,$key,@info) = @_;
	my ($buf, $text, $txt) = ("","","");
	my ($len,$blocklen,$padlen) = (0,0,0);
	if ($output) {
		open(OUT,">>$output") or throw Error::Mimetic "Cannot open $output: $!";
	}
	open(IN,"$filename") or throw Error::Mimetic "Cannot open $filename: $!";
	$key = Crypt::Mimetic::GetConfirmedPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	my $cs = new Crypt::CipherSaber($key); 
	while ( read(IN,$buf,32768) ) {
		$blocklen = $padlen;
		$text = $cs->encrypt($buf);
		$padlen = length($text);
		$len += $padlen;
		if ($output) {
			print OUT $text;
		} else {
			$txt .= $text;
		}
	}
	close(IN);
	if ($output) {
		close(OUT);
		return ($len,$blocklen,$padlen);
	}
	return ($len,$blocklen,$padlen,$txt);
}

#
# string EncryptString($string,$algorithm,$key,@info)
#
sub EncryptString {
	my ($string,$algorithm,$key,@info) = @_;
	$key = Crypt::Mimetic::GetConfirmedPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	my $cs = new Crypt::CipherSaber($key); 
	return $cs->encrypt($string);
}

#
# [string] DecryptFile($filename,$output,$offset,$len,$algorithm,$key,@info)
#
sub DecryptFile {
	my ($filename,$output,$offset,$len,$algorithm,$key,@info) = @_;
	my ($blocklen,$padlen) = @info;
	my ($buf, $text, $i, $txt) = ("","",0,"");
	my $blocks = 0;
	$blocks = int($len/$blocklen) if $blocklen;
	if ($output) {
		open(OUT,">$output") or throw Error::Mimetic "Cannot open $output: $!";
	}
	open(IN,"$filename") or throw Error::Mimetic "Cannot open $filename: $!";
	$key = Crypt::Mimetic::GetPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	my $cs = new Crypt::CipherSaber($key); 
	seek IN, $offset, 0;
	for ($i = 0; $i < $blocks; $i++ ) {
		read(IN,$buf,$blocklen);
		$text = $cs->decrypt($buf);
		if ($output) {
			print OUT $text;
		} else {
			$txt .= $text;
		}
	}
	read(IN,$buf,$padlen);
	$text = $cs->decrypt($buf);
	if ($output) {
		print OUT $text;
	} else {
		$txt .= $text;
	}
	close(IN);
	if ($output) {
		close(OUT);
	} else {
		return $txt;
	}
}

#
# string DecryptString($string,$algorithm,$key,@info)
#
sub DecryptString {
	my ($string,$algorithm,$key,@info) = @_;
	$key = GetPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	my $cs = new Crypt::CipherSaber($key); 
	return $cs->decrypt($string);
}

1;

=pod

=head1 NAME

Crypt::Mimetic::CipherSaber - CipherSaber Encryption Algorithm

	
=head1 DESCRIPTION

This module is a part of I<Crypt::Mimetic>.

This modules uses CipherSaber to encrypt blocks of bytes, so I<DecryptFile> needs @info containing generic-blocks-length and last-block-length (padlen) to know how decrypt a file. I<EncryptString> and I<DecryptString> always encrypt/decrypt a string as a single block.


=head1 SYNOPSIS

=item string I<ShortDescr> ()

Return a short description of algorithm


=item boolean I<PasswdNeeded> ()

Return true if password is needed by this algorithm, false otherwise.
('CipherSaber' return always true)


=item ($len,$blocklen,$padlen,[string]) I<EncryptFile> ($filename,$output,$algorithm,$key,@info)

Encrypt a file with CipherSaber algorithm. See I<Crypt::Mimetic::EncryptFile>.


=item string I<EncryptString> ($string,$algorithm,$key,@info)

Encrypt a string with CipherSaber algorithm. See I<Crypt::Mimetic::EncryptString>.


=item [string] I<DecryptFile> ($filename,$output,$offset,$len,$algorithm,$key,@info)

Decrypt a file with CipherSaber algorithm. See I<Crypt::Mimetic::DecryptFile>.


=item string I<DecryptString> ($string,$algorithm,$key,@info)

Decrypt a string with CipherSaber algorithm. See I<Crypt::Mimetic::DecryptString>.


=head1 NEEDED MODULES

This module needs:
   Crypt::Mimetic
   Error::Mimetic
   Crypt::CipherSaber


=head1 SEE ALSO

Crypt::Mimetic


=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself (Artistic/GPL2).


=head1 AUTHOR

Erich Roncarolo <erich-roncarolo@users.sourceforge.net>

=cut
