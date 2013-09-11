package Catmandu::XML;
# ABSTRACT: Modules for handling XML data within the Catmandu framework
our $VERSION = '0.01'; # VERSION


1;

__END__
=pod

=head1 NAME

Catmandu::XML - Modules for handling XML data within the Catmandu framework

=head1 VERSION

version 0.01

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

=back

=encoding utf8

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

