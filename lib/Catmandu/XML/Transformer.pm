package Catmandu::XML::Transformer;
#ABSTRACT: Utility module for XSLT processing
our $VERSION = '0.04'; #VERSION

use Catmandu::Sane;
use Moo;
use XML::LibXML;
use XML::LibXSLT;
use Scalar::Util qw(blessed);
use XML::Struct::Reader;
use XML::Struct::Writer;

has stylesheet => (
    is       => 'ro',
    required => 1,
    coerce   => sub {
        my $xslt = XML::LibXML->load_xml(location => $_[0], no_cdata=>1);
        XML::LibXSLT->new()->parse_stylesheet($xslt);
    }
);

sub transform {
    my ($self, $xml) = @_;

    # DOM to DOM
    if (blessed $xml && $xml->isa('XML::LibXML::Document')) {
        return $self->stylesheet->transform($xml);
    # MicroXML to MicroXML
    } elsif (ref $xml) {
        $xml = XML::Struct::Writer->new->write( $xml );
        my $result = $self->stylesheet->transform( $xml );
        return XML::Struct::Reader->new( from => $result )->readDocument;
    # string to string
    } else {
        $xml = XML::LibXML->load_xml(string => $xml);
        my $result = $self->stylesheet->transform($xml);
        return $self->stylesheet->output_as_chars($result);
    }

    return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::XML::Transformer - Utility module for XSLT processing

=head1 VERSION

version 0.04

=head1 SYNOPISIS

    my $transformer = Catamandu::XML::Transformer->new( stylesheet => 'file.xsl' );

    $xml_string = $transformer->transform( $xml_string );
    $xml_dom    = $transformer->transform( $xml_dom );
    $xml_struct = $transformer->transform( $xml_struct );

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
