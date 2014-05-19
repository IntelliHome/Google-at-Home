package IntelliHome::Schema::Mongo::Notification;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with('IntelliHome::Schema::Mongo::Role::Plugin');
has 'broadcast' => (is=>"rw", isa=>"Bool",default=>1); #defaults response is broadcasted to all nodes, otherwise should detect where the user(s) are/is
has 'time_interval' => ( is => "rw" );
has 'entropy' => ( is => "rw", isa => "Bool", default => 0 );
1;
