=pod

=head1 NAME

Crypt::Mimetic::TEA - Tiny Encryption Algorithm

	
=head1 DESCRIPTION

This module is a part of I<Crypt::Mimetic>.

This modules uses TEA to encrypt blocks of bytes, so I<DecryptFile> needs @info containing generic-blocks-length and last-block-length (padlen) to know how decrypt a file. I<EncryptString> and I<DecryptString> always encrypt/decrypt a string as a single block.

=cut

package Crypt::Mimetic::TEA;
use strict;
use Error::Mimetic;
use vars qw($VERSION);
$VERSION = '0.01';

eval 'use Crypt::Tea';
die ("Crypt::Tea required by ". __PACKAGE__) if $@;

=pod

=head1 PROCEDURAL INTERFACE

=item string I<ShortDescr> ()

Return a short description of algorithm

=cut

sub ShortDescr {
	return "TEA - Tiny Encryption Algorithm.";
}

=pod

=item boolean I<PasswdNeeded> ()

Return true if password is needed by this algorithm, false otherwise.
('TEA' return always true)

=cut

sub PasswdNeeded {
	return 1;
}

=pod

=item ($len,$blocklen,$padlen,[string]) I<EncryptFile> ($filename,$output,$algorithm,$key,@info)

Encrypt a file with TEA algorithm. See I<Crypt::Mimetic::EncryptFile>.

=cut

sub EncryptFile {
	my ($filename,$output,$algorithm,$key,@info) = @_;
	my ($buf, $text, $txt) = ("","","");
	my ($len,$blocklen,$padlen) = (0,0,0);
	if ($output) {
		open(OUT,">>$output") or throw Error::Mimetic "Cannot open $output: $!";
	}
	open(IN,"$filename") or throw Error::Mimetic "Cannot open $filename: $!";
	$key = Crypt::Mimetic::GetConfirmedPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	while ( read(IN,$buf,32768) ) {
		$blocklen = $padlen;
		$text = encrypt($buf,$key);
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

=pod

=item string I<EncryptString> ($string,$algorithm,$key,@info)

Encrypt a string with TEA algorithm. See I<Crypt::Mimetic::EncryptString>.

=cut

sub EncryptString {
	my ($string,$algorithm,$key,@info) = @_;
	$key = Crypt::Mimetic::GetConfirmedPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	return &encrypt ($string, $key);
}

=pod

=item [string] I<DecryptFile> ($filename,$output,$offset,$len,$algorithm,$key,@info)

Decrypt a file with TEA algorithm. See I<Crypt::Mimetic::DecryptFile>.

=cut

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
	seek IN, $offset, 0;
	for ($i = 0; $i < $blocks; $i++ ) {
		read(IN,$buf,$blocklen);
		$text = decrypt($buf,$key);
		if ($output) {
			print OUT $text;
		} else {
			$txt .= $text;
		}
	}
	read(IN,$buf,$padlen);
	$text = decrypt($buf,$key);
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

=pod

=item string I<DecryptString> ($string,$algorithm,$key,@info)

Decrypt a string with TEA algorithm. See I<Crypt::Mimetic::DecryptString>.

=cut

sub DecryptString {
	my ($string,$algorithm,$key,@info) = @_;
	$key = GetPasswd() or throw Error::Mimetic "Password is needed" unless $key;
	return &decrypt ($string, $key);
}

1;
__END__

=pod

=head1 NEEDED MODULES

This module needs:
   Error::Mimetic
   Crypt::Tea


=head1 KNOWN BUGS

Seems to be quite slow.


=head1 SEE ALSO

Crypt::Mimetic


=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself (Artistic/GPL2).


=head1 AUTHOR

Erich Roncarolo <erich-roncarolo@users.sourceforge.net>

=cut
