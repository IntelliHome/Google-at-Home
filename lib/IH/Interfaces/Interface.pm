package IH::Interfaces::Interface;

use Time::Piece;

use Moo;

sub setLogFile() {
    my $month = Time::Piece->new->strftime('%m');
    my $day   = Time::Piece->new->strftime('%d');
    my $year  = Time::Piece->new->strftime('%Y');
    mkdir("/var/log/intellihome") if ( !-d "/var/log/intellihome" );
    mkdir( "/var/log/intellihome/" . $year )
        if ( !-d "/var/log/intellihome/" . $year );
    mkdir( "/var/log/intellihome/" . $year . "/" . $month )
        if ( !-d "/var/log/intellihome/" . $year . "/" . $month );
    Log::Any::Adapter->set( 'File',
              "/var/log/intellihome/"
            . $year . "/"
            . $month . "/"
            . $day
            . "-intellihome.log" )
        if ( -d "/var/log/intellihome/" . $year . "/" . $month );

}


sub AUTOLOAD {
    our $AUTOLOAD;
    my $self   = shift;
    my $caller = caller();
    ( my $method = $AUTOLOAD ) =~ s/.*:://s;    # remove package name
    my $printable = uc($method);
    &setLogFile();
    $self->display($caller,$method,@_);

}

return 1;

__DATA__
