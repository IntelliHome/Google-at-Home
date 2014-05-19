package IntelliHome::Schema::Mongo::PluginOption;
use Moose;
has 'key'    => ( is => "rw" );
has 'value'  => ( is => "rw" );
has 'plugin' => ( is => "rw" );
1;
