package Catalyst::App::RoleApplicator;
# ABSTRACT: apply roles to your Catalyst application-related classes

use strict;
use warnings;
use Moose ();
use Moose::Util::MetaRole;
use Moose::Exporter;
use MooseX::Role::RelatedClassRoles;

Moose::Exporter->setup_import_methods();

sub init_meta {
  my $self = shift;
  my %p = @_;
  my $meta = Moose->init_meta(%p);

  # leave out context_class because it's set later in Catalyst.pm instead of
  # up-front, so anyone who doesn't set it will get explosions; also, it's just
  # MyApp, most of the time, so add your own roles
  for (qw(request response engine dispatcher stats)) {
    Class::MOP::class_of('MooseX::Role::RelatedClassRoles')
      ->apply($meta, name => $_, require_class_accessor => 0);
  }

  return $meta;
}

1;

__END__

=head1 SYNOPSIS

  package MyApp;

  use base 'Catalyst';
  use Catalyst;
  use Catalyst::App::RoleApplicator;

  __PACKAGE__->apply_request_class_roles(
    qw/My::Request::Role Other::Request::Role/
  );

=head1 DESCRIPTION

Catalyst::App::RoleApplicator makes it easy for you to apply roles to all the
various classes that your Catalyst application uses.

=method apply_request_class_roles

=method apply_response_class_roles

=method apply_engine_class_roles

=method apply_dispatcher_class_roles

=method apply_stats_class_roles

Apply the named roles to one of the classes your application uses.

=method init_meta

Apply the Moose extensions that power this class.

=cut
