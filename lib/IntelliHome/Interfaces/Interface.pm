package IntelliHome::Interfaces::Interface;
use Log::Any::Adapter;
use Time::Piece;
use Moo;
with 'MooX::Singleton';
has 'Today'  => ( is => "rw" );
has 'Year'   => ( is => "rw" );
has 'Month'  => ( is => "rw" );
has 'Config' => ( is => "rw" );
has 'log'    => ( is => "rw", default => sub {1} );

sub setLogFile {
    my $self = shift;
    return 1 if ( $self->log != 1 );
    my $month = Time::Piece->new->strftime('%m');
    my $day   = Time::Piece->new->strftime('%d');
    my $year  = Time::Piece->new->strftime('%Y');

    return 1
        if ($self->Today
        and $self->Today == $day
        and $self->Year
        and $self->Year == $year
        and $self->Month
        and $self->Month == $month );
    $self->Today($day);
    $self->Year($year);
    $self->Month($month);
    mkdir("/var/log/intellihome") if ( !-d "/var/log/intellihome" );
    mkdir( "/var/log/intellihome/" . $year )
        if ( !-d "/var/log/intellihome/" . $year );
    mkdir( "/var/log/intellihome/" . $year . "/" . $month )
        if ( !-d "/var/log/intellihome/" . $year . "/" . $month );

    if ( -d "/var/log/intellihome/" . $year . "/" . $month ) {
        Log::Any::Adapter->set( 'File',
                  "/var/log/intellihome/"
                . $year . "/"
                . $month . "/"
                . $day
                . "-intellihome.log" );
    }
    else {
        Log::Any::Adapter->set( 'File', "./intellihome.log" );
    }

}

sub AUTOLOAD {
    our $AUTOLOAD;
    my $self   = shift;
    my $caller = caller();
    ( my $method = $AUTOLOAD ) =~ s/.*:://s;    # remove package name
    my $printable = uc($method);
    if ( $method ne "DESTROY" ) {
        $self->setLogFile();
        $self->display( $caller, $method, @_ );
    }
}

return 1;

__DATA__
