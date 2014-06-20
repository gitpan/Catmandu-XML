package Catmandu::Fix::xml_transform;
#ABSTRACT: transform XML using XSLT stylesheet
our $VERSION = '0.06'; #VERSION

use Catmandu::Sane;
use Moo;
use XML::LibXML;
use XML::LibXSLT;

use Catmandu::XML::Transformer;

with 'Catmandu::Fix::Base';

has field => (
    is => 'ro',
    required => 1
);
has file => (
    is => 'ro',
    required => 1
);
has _transformer => (
    is => 'ro',
    lazy => 1,
    default => sub {
        Catmandu::XML::Transformer->new( stylesheet => $_[0]->file );
    }
);

around BUILDARGS => sub {
    my($orig,$class,$field,%opts) = @_;
    $orig->($class,field => $field,file => $opts{file});
};

sub emit {    
    my ($self,$fixer) = @_;    

    my $path = $fixer->split_path($self->field());
    my $key = pop @$path;
    
    my $transformer = $fixer->capture($self->_transformer); 

    return $fixer->emit_walk_path($fixer->var,$path,sub{
        my $var = $_[0];     
        $fixer->emit_get_key($var,$key,sub{
            my $var = $_[0];
            return "${var} = ${transformer}->transform(${var});";
        });
    });
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::Fix::xml_transform - transform XML using XSLT stylesheet

=head1 VERSION

version 0.06

=head1 SYNOPSIS

  # Transforms the 'xml' from marcxml to dublin core xml
  xml_transform('xml',file => 'marcxml2dc.xsl');

=head1 DESCRIPTION

This L<Catmandu::Fix> transforms XML with an XSLT stylesheet. Based on
L<Catmandu::XML::Transformer> the fix will transform and XML string into an XML
string, MicroXML (L<XML::Struct>) into MicroXML, and a DOM into a DOM.

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
