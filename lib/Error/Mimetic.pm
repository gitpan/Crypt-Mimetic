#
# The error class definition for Mimetic (see Error module)
#

package Error::Mimetic;
use Error;
use strict;
use vars qw($VERSION);
$VERSION = '0.01';

@Error::Mimetic::ISA = qw(Error::Simple);

sub new {
	my ($self, $text, $details) = @_;
	my $s = $self->SUPER::new($text,0);
	$s->{'-object'} = $details;
	return $s;
}

sub stringify {
	my $self = shift;
	my $cache = $self->{'-cache'};
	return $cache if $cache;
	my $obj = $self->{'-object'};
	$self->{'-text'} .= ".\n" unless $Error::Debug > 1;
	my $s = $self->SUPER::stringify;
	if ($Error::Debug > 0 && $obj) {
		my @lines = split /\n/, $obj;
		chomp(@lines);
		$obj = $lines[0];
		chomp $s;
		$s .= " - $obj";
		chomp $s;
		if ($Error::Debug < 2) {
			$s =~ s/ at (\S+) line (\d+)(\.)*$//s  ||
				$s =~ s/ at \(.*?\) line (\d+)(\.)*$//s;
		}
		$s .= "\n";
	}
	$self->{'-cache'} = $s;
	return $s;
}

=pod

=head1 NAME

Error::Mimetic - The error class definition for Crypt::Mimetic (see Error module)

=head1 DESCRIPTION

This module is a part of I<Crypt::Mimetic> distribution.

This module extends I<Error::Simple>. It's constructor takes two arguments:
the first is the error description, the second are details.

If I<$Error::Debug> is == 0, then only description is printed.

If I<$Error::Debug> is > 0, then details are printed after description.

If I<$Error::Debug> is > 1, then description, details and informations about files
and lines where error raised are printed.

=head1 NEEDED MODULES

This module needs:
   Error

=head1 SEE ALSO

Error(3), Crypt::Mimetic(3)

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself (Artistic/GPL2).

=head1 AUTHOR

Erich Roncarolo <erich-roncarolo@users.sourceforge.net>

=cut

