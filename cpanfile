requires 'AnyEvent';
requires 'AnyEvent::Filesys::Notify';
requires 'Carp::Always';
requires 'Encode';
requires 'File::Find::Object';
requires 'Getopt::Long';
requires 'LWP::UserAgent';
requires 'Log::Any';
requires 'Log::Any::Adapter';
requires 'Mojo::Base';
requires 'Mojo::Loader';
requires 'MojoX::JSON::RPC::Service';
requires 'Mojolicious::Commands';
requires 'Mojolicious::Plugin::JsonRpcDispatcher';
requires 'Mongoose';
requires 'Mongoose::Class';
requires 'Mongoose::Document';
requires 'Moo';
requires 'Moo::Role';
requires 'MooX::Singleton';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::Singleton';
requires 'Net::SSH::Any';
requires 'Term::ANSIColor';
requires 'Time::HiRes';
requires 'Time::Piece';
requires 'URI';
requires 'Unix::PID';
requires 'YAML::Tiny';
requires 'feature';
requires 'namespace::autoclean';

on configure => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Test::More';
};
