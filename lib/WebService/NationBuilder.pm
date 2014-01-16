package WebService::NationBuilder;

use strict;
use warnings;
use Moo;

with 'WebService::NationBuilder::HTTP';

use Carp qw(croak);

has access_token => ( is => 'ro'                                 );
has subdomain    => ( is => 'ro'                                 );
has domain       => ( is => 'ro', default => 'nationbuilder.com' );
has version      => ( is => 'ro', default => 'v1'                );

has sites_uri    => ( is => 'ro', default => 'sites'             );
has people_uri   => ( is => 'ro', default => 'people'            );
has tags_uri     => ( is => 'ro', default => 'tags'              );

sub get_sites {
    my ($self, $params) = @_;
    return $self->http_get_all($self->sites_uri, $params);
}

sub create_person {
    my ($self, $params) = @_;
    my $person = $self->http_post($self->people_uri, {
        person => $params });
    return $person ? $person->{person} : 0;
}

sub push_person {
    my ($self, $params) = @_;
    my $person = $self->http_put($self->people_uri . '/push', {
        person => $params });
    return $person ? $person->{person} : 0;
}

sub update_person {
    my ($self, $id, $params) = @_;
    croak 'The id param is missing' unless defined $id;
    my $person = $self->http_put($self->people_uri . "/$id", {
        person => $params });
    return $person ? $person->{person} : 0;
}

sub get_person {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    my $person = $self->http_get($self->people_uri . "/$id");
    return $person ? $person->{person} : 0;
}

sub delete_person {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    return $self->http_delete($self->people_uri . "/$id");
}

sub get_person_tags {
    my ($self, $id) = @_;
    croak 'The id param is missing' unless defined $id;
    my $taggings = $self->http_get($self->people_uri . "/$id/taggings");
    return $taggings ? $taggings->{taggings} : 0;
}

sub match_person {
    my ($self, $params) = @_;
    return $self->http_get($self->people_uri . '/match', $params)->{person};
}

sub get_people {
    my ($self, $params) = @_;
    return $self->http_get_all($self->people_uri, $params);
}

sub get_tags {
    my ($self, $params) = @_;
    return $self->http_get_all($self->tags_uri, $params);
}

sub set_tag {
    my ($self, $id, $tag) = @_;
    croak 'The id param is missing' unless defined $id;
    croak 'The tag param is missing' unless defined $tag;
    my $tagging = $self->http_put($self->people_uri . "/$id/taggings", {
        tagging => { tag => $tag },
    });
    return $tagging ? $tagging->{tagging} : 0;
}

sub delete_tag {
    my ($self, $id, $tag) = @_;
    croak 'The id param is missing' unless defined $id;
    croak 'The tag param is missing' unless defined $tag;
    return $self->http_delete($self->people_uri . "/$id/taggings/$tag");
}

# ABSTRACT: NationBuilder API bindings


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::NationBuilder - NationBuilder API bindings

=head1 VERSION

version 0.0100

=head1 SYNOPSIS

    use WebService::NationBuilder;
    
    my $nb = WebService::NationBuilder->new(
        access_token    => 'abc123',
        subdomain       => 'testing',
    );

    $nb->get_sites();

=head1 DESCRIPTION

This module provides bindings for the
L<NationBuilder|https://www.nationbuilder.com> API.

=head1 METHODS

=head2 new

    my $nb = WebService::NationBuilder->new(
        access_token    => $access_token,
        subdomain       => $subdomain,
        domain          => $domain,     # optional
        version         => $version,    # optional
        retries         => $retries,    # optional
    );

Instantiates a new WebService::NationBuilder client object.

=head2 get_sites

=head2 get_people

=head2 get_person

=head2 match_person

=head2 create_person

=head2 update_person

=head2 push_person

=head2 delete_person

=head2 get_tags

=head2 get_person_tags

=head2 set_tag

=head2 delete_tag

=head1 METHODS

=head1 AUTHOR

Ali Anari <ali@anari.me>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Crowdtilt, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
