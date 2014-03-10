package IH::Schema::Mongo::Task;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'tasks',

    # -pk              => [qw/ title /]
};

#has 'title' => ( is => "rw" );
has 'status'     => ( is => "rw" );
has 'node'       => ( is => "rw", isa => "IH::Node" );
has 'trigger'    => ( is => "rw", isa => "IH::Schema::Mongo::Trigger" );
has 'start_time' => ( is => "rw", default => sub { time(); } );
1;
