package Catmandu::Importer::XML;
# ABSTRACT: Import serialized XML documents
our $VERSION = '0.01'; # VERSION

use namespace::clean;
use Catmandu::Sane;
use Moo;
use XML::Struct::Reader;

with 'Catmandu::Importer';

has type => (is => 'ro', default => sub { 'simple' });
has path => (is => 'ro', default => sub { '/*' });
has root => (is => 'ro');
has attributes => (is => 'ro', default => sub { 1 });
has whitespace => (is => 'ro', default => sub { 0 });

sub generator {
    my ($self) = @_;

    sub {
        state $reader = do { 
            my %options = (
                from       => ($self->file || $self->fh),
                path       => $self->path,
                whitespace => $self->whitespace,
                attributes => $self->attributes,
            );
            if ($self->type eq 'simple') {
                $options{simple} = 1;
                $options{root}   = $self->root;
            } elsif ($self->type ne 'ordered') {
                return;
            }
            XML::Struct::Reader->new(%options);
        };

        return $reader->readNext;
    }
}


1;

__END__
=pod

=head1 NAME

Catmandu::Importer::XML - Import serialized XML documents

=head1 VERSION

version 0.01

=head1 DESCRIPTION

This importer reads XML and transforms it into a data structure. Two types of
structure can be choosen among:

=over 4

=item simple (default)

Elements and attributes and converted to keys in a key-value structure. For instance

    <doc attr="value">
      <field1>foo</field1>
      <field1>bar</field1>
      <bar>
        <doz>baz</doz>
      </bar>
    </doc>

is imported as

      {
        attr => 'value',
        field1 => [ 'foo', 'bar' ],
        field2 => { 'doz' => 'baz' },
      }

=item ordered

Elements are preserved in the order of their appereance. For instance the
sample document above is imported as:

        [ 
            doc => { attr => "value" }, [
                [ field1 => { }, ["foo"] ],
                [ field1 => { },  ["bar"] ],
                [ field2 => { }, [ [ doz => { }, ["baz"] ] ] ]
            ]
        ] 

Attributes can be omitted with option C<attributes>.

=back

=head1 CONFIGURATION

=over 4

=item attributes

=item path

=item root

=item whitespace

=back

=encoding utf8

=head1 SEE ALSO

This module is just a thin layer on top of L<XML::Struct::Reader>.

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

