package IH::Connector;

use Moose;
use IH::Workers::SocketListener;
use IO::Socket;

has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});
has 'Worker' => (is=>"rw");
has 'Config'   => (is=>"rw"); #if has config can auto select where things must be done
has 'Socket'	=> (is=>"rw");
has 'Node'     => (is=>"rw");

sub broadcastMessage(){
		my $self=shift;
		my $Type =shift;
	my $Message=shift;
	my $Nodes=$self->Config->Nodes;
	foreach my $Node (keys (%{$Nodes} ) ){
		if($Nodes->{$Node}->{type} eq $Type){
			$self->Node->select($Nodes,$Node);
			$self->connect();
			$self->send_command($Message);
		}
	}
}

sub listen(){
	my $self=shift;

	return 0 if (!$self->Worker);

	my ($filename,$new, $fh, @ready);

	my $lsn = IO::Socket::INET->new(
		Listen => 1,
		LocalAddr => $self->Node->Host,
		LocalPort => $self->Node->Port,
	) or $self->Output->error("Can't create server socket: $!");


while (my $client=$lsn->accept()) 
{
	my $Thread = IH::Workers::SocketListener->new(Worker=>$self->Worker , Socket=>$client);
    $Thread->launch();
}


}

sub connect(){
	my $self=shift;
	 my $server = IO::Socket::INET->new(Proto => "tcp",
                                       PeerPort => $self->Node->Port,
                                       PeerAddr => $self->Node->Host,
                                       Timeout => 2000)
                 || $self->Output->error("failed to connect to the server");
         
     $self->Socket($server);
     return $self;
}


sub send_file(){
	 my $self=shift;
	 my $File =shift;
    my $server = IO::Socket::INET->new(Proto => "tcp",
                         PeerPort => $self->Node->Port,
                                       PeerAddr => $self->Node->Host,
                                       Timeout => 2000)
                 || $self->Output->error("failed to connect to the server");
                 if($server){
             open FILE, "<".$File or $self->Output->error("Error: $!");
             while (<FILE>) 
             {
                 print $server $_;
             }
             close FILE;   
             $server->close();
         }
}


sub send_command(){
	my $self=shift;
	my $Command=shift;
	if($self->Socket){
		my $Sock=$self->Socket();
		print $Sock $Command;
		$self->Socket->close();
	} else {
		$self->connect();
		$self->send_command($Command);
	}
}

1;