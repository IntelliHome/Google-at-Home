package IntelliHome::Interfaces::Interface;
use Log::Any::Adapter;
use Time::Piece;
use Moo;
with 'MooX::Singleton';
use constant LOG_DIR => $ENV{HOME} . '/.intellihome/logs/';
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
    mkdir(LOG_DIR) if ( !-d LOG_DIR );
    mkdir( LOG_DIR . $year )
        if ( !-d LOG_DIR . $year );
    mkdir( LOG_DIR . $year . "/" . $month )
        if ( !-d LOG_DIR . $year . "/" . $month );

    if ( -d LOG_DIR . $year . "/" . $month ) {
        Log::Any::Adapter->set( 'File',
                  LOG_DIR
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
