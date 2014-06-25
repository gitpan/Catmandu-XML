package Catmandu::XML;
#ABSTRACT: Modules for handling XML data within the Catmandu framework
our $VERSION = '0.10'; #VERSION


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::XML - Modules for handling XML data within the Catmandu framework

=head1 VERSION

version 0.10

=head1 DESCRIPTION

L<Catmandu::XML> contains modules for handling XML data within the L<Catmandu>
framework. Parsing and serializing is based on L<XML::LibXML> with
L<XML::Struct>.

=head1 MODULES

=over 4

=item L<Catmandu::Importer::XML>

Import serialized XML documents as data structures.

=item L<Catmandu::Exporter::XML>

Serialize data structures as XML documents.

=item L<Catmandu::Fix::xml_read>

Fix function to parse XML to MicroXML as implemented by L<XML::Struct>

=item L<Catmandu::Fix::xml_write>

Fix function to seralize XML.

=item L<Catmandu::Fix::xml_simple>

Fix function to parse XML or convert MicroXML to simple form as known from
L<XML::Simple>.

=item L<Catmandu::Fix::xml_transform>

Fix function to transform XML using XSLT stylesheets.

=back

=head1 SEE ALSO

This module requires the non-perl libraries libxml2 and libxslt installed. To
install for instance on Ubuntu Linux call C<sudo apt-get install libxslt-dev
libxml2-dev>.

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
