package IntelliHome::Schema::YAML::Node;
use Moo;
use IntelliHome::Utils qw(load_module);
has 'Deployer' => ( is => "rw" );
has 'Username' => ( is => "rw" );
has 'Password' => ( is => "rw" );
has 'Host'     => ( is => "rw", default => 'localhost' );
has 'Port'     => ( is => "rw", default => '23456' );
has 'HW'       => ( is => "rw" );
has 'type'     => ( is => "rw" );
has 'Config'   => ( is => "rw" )
    ;    #if has config can auto select where things must be done
has 'Description' => ( is => "rw" );
has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->new }
);

has 'mic_lower_threshold' => ( is => "rw" );
has 'mic_upper_threshold' => ( is => "rw" );
has 'mic_capture_level'   => ( is => "rw" );
has 'mic_boost_level'     => ( is => "rw" );
has 'mic_step'            => ( is => "rw" );

sub select {
    my $self  = shift;
    my $Nodes = shift;
    my $Node  = shift;
    $self->Host($Node);
    $self->Port( $Nodes->{$Node}->{port} );
    $self->Username( $Nodes->{$Node}->{username} );
    $self->Password( $Nodes->{$Node}->{password} );
    $self->Description( $Nodes->{$Node}->{description} );
    $self->type( $Nodes->{$Node}->{type} );
    $self->HW( $Nodes->{$Node}->{HW} ) if ( $Nodes->{$Node}->{HW} );
    $self->mic_boost_level( $Nodes->{$Node}->{mic_boost_level} )
        if ( $Nodes->{$Node}->{mic_boost_level} );
    $self->mic_capture_level( $Nodes->{$Node}->{mic_capture_level} )
        if ( $Nodes->{$Node}->{mic_capture_level} );
    $self->mic_upper_threshold( $Nodes->{$Node}->{mic_upper_threshold} )
        if ( $Nodes->{$Node}->{mic_upper_threshold} );
    $self->mic_lower_threshold( $Nodes->{$Node}->{mic_lower_threshold} )
        if ( $Nodes->{$Node}->{mic_lower_threshold} );
    $self->mic_step( $Nodes->{$Node}->{mic_step} )
        if ( $Nodes->{$Node}->{mic_step} );

    if ( exists( $Nodes->{$Node}->{deployer} ) ) {
        my $Deployer = $Nodes->{$Node}->{deployer};

        #  $self->Output->info( "Deployer present: " . $Deployer );
        $self->Deployer( $Deployer->new( Node => $self ) )
            if load_module($Deployer);
    }
    else {
        # $self->Output->info("Deployer not present :(");
    }

    # $self->Output->debug( "Selected node: " . $self->Host );

    return $self;
}

sub customSelect {
    my $self   = shift;
    my $field  = shift;
    my $custom = shift;
    my $Nodes  = $self->Config->Nodes;
    foreach my $Node ( keys( %{$Nodes} ) ) {
        if ( $Nodes->{$Node}->{$field} eq $custom ) {
            $self->select( $Nodes, $Node );
        }
    }
    return $self;

}

sub selectFromType {
    my $self  = shift;
    my $type  = shift;
    my $Nodes = $self->Config->Nodes;
    foreach my $Node ( keys( %{$Nodes} ) ) {
        if ( $Nodes->{$Node}->{type} eq $type ) {
            $self->select( $Nodes, $Node );
        }
    }
    return $self;
}

sub selectFromHost {
    my $self  = shift;
    my $H     = shift;
    my $type  = shift || "node";
    my $Nodes = $self->Config->Nodes;
    foreach my $Node ( keys( %{$Nodes} ) ) {
        if ( $Node eq $H and $Nodes->{$Node}->{type} eq $type ) {
            $self->select( $Nodes, $Node );

        }
    }
    return $self;

}

sub selectFromDescription {
    my $self  = shift;
    my $H     = shift;
    my $Nodes = $self->Config->Nodes;
    foreach my $Node ( keys( %{$Nodes} ) ) {
        next if !$Nodes->{$Node}->{description};
        if ( $Nodes->{$Node}->{description} eq $H ) {
            $self->select( $Nodes, $Node );

        }
    }
    return $self;

}

sub deploy {
    my $self = shift;
    if ( $self->Deployer ) {
        $self->Deployer()->deploy();

    }
    else {
        $self->Output->warn("Deployer not configured");
    }
    return $self;
}

1;
