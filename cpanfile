requires 'AnyEvent';
requires 'AnyEvent::Filesys::Notify';
requires 'Encode';
requires 'File::Find::Object';
requires 'Getopt::Long';
requires 'IH::IntelliHomeAgent';
requires 'LWP::UserAgent';
requires 'Log::Any';
requires 'Log::Any::Adapter';
requires 'Module::Load';
requires 'Mongoose';
requires 'Mongoose::Class';
requires 'Mongoose::Document';
requires 'Moo';
requires 'MooX::Singleton';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::Singleton';
requires 'Net::SSH::Any';
requires 'Proc::Daemon';
requires 'Term::ANSIColor';
requires 'Time::HiRes';
requires 'Time::Piece';
requires 'Try::Tiny';
requires 'URI';
requires 'Unix::PID';
requires 'YAML::Tiny';
requires 'namespace::autoclean';

on configure => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Test::More';
};
