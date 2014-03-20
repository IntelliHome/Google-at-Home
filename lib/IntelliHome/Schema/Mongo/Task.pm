package IntelliHome::Schema::Mongo::Task;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'tasks',

    # -pk              => [qw/ title /]
};

#has 'title' => ( is => "rw" );
has 'status'     => ( is => "rw" );
has 'node'       => ( is => "rw", isa => "IntelliHome::Node" );
has 'trigger'    => ( is => "rw", isa => "IntelliHome::Schema::Mongo::Trigger" );
has 'start_time' => ( is => "rw", default => sub { time(); } );
1;
