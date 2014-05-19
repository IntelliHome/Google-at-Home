package IntelliHome::Schema::Mongo::Role::Plugin;
use Moose::Role;
use namespace::autoclean;

has 'plugin'        => ( is => "rw" );
has 'plugin_method' => ( is => "rw" );
1;