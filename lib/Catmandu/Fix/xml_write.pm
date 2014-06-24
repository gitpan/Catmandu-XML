package Catmandu::Fix::xml_write;
#ABSTRACT: parse XML
our $VERSION = '0.08'; #VERSION

use Catmandu::Sane;
use Moo;
use XML::Struct::Writer;
use XML::LibXML::Reader;

with 'Catmandu::Fix::Base';

has field      => (is => 'ro', required => 1);
has attributes => (is => 'ro'); 
has pretty     => (is => 'ro');
has encoding   => (is => 'ro', default => sub { 'UTF-8' });
has version    => (is => 'ro');
has standalone => (is => 'ro');
has xmldecl    => (is => 'ro', default => sub { 1 });

around BUILDARGS => sub {
    my ($orig,$class,$field,%opts) = @_;
    $orig->($class, 
        field      => $field,
        map { $_ => $opts{$_} } grep { defined $opts{$_} }
        qw(attributes pretty encoding version standalone xmldecl)
    );
};

has _writer => (
    is      => 'ro',
    lazy    => 1,
    builder => sub {
        XML::Struct::Writer->new(
            map { $_ => $_[0]->$_ } grep { defined $_[0]->$_ }
            qw(attributes pretty encoding version standalone xmldecl)
        );
    }
);

sub emit {    
    my ($self,$fixer) = @_;    

    my $path = $fixer->split_path($self->field);
    my $key = pop @$path;
    
    my $writer = $fixer->capture($self->_writer); 
    my $pretty = $fixer->capture($self->pretty); 

    return $fixer->emit_walk_path($fixer->var,$path,sub{
        my $var = $_[0];     
        $fixer->emit_get_key($var,$key,sub{
            my $var = $_[0];
            return "${var} = (ref(${var}) =~ 'XML::LibXML::Document=')" .
                   "? ${var}->serialize(${pretty}) : do {".
                       "my \$s=''; ${writer}->to(\\\$s); ${writer}->write(${var}); \$s" .
                   "}";
        });
    });
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::Fix::xml_write - parse XML

=head1 VERSION

version 0.08

=head1 SYNOPSIS

  # serialize XML structure given in field 'xml' 
  xml_write(xml)
  xml_write(xml, pretty: 1)

=head1 DESCRIPTION

This L<Catmandu::Fix> serializes XML documents (given in MicroXML form
as used by L<XML::Struct> or as instance of L<XML::LibXML::Document>).
In short, this is a wrapper around L<XML::Struct::Writer>.

=head1 CONFIGURATION

=over

=item attributes

Set to false to not expect attribute hashes in the XML structure.

=item pretty

Pretty-print XML if set to C<1>.

=item xmldecl

=item version

=item encoding

=item standalone

=back

=head1 SEE ALSO

L<Catmandu::Fix::xml_read>

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
