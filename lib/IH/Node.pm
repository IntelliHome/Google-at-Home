package IH::Node;
use Moo;
has 'Deployer' => (is=>"rw");
has 'Username' => (is=>"rw");
has 'Password' => (is=>"rw");
has 'Host' => (is=>"rw", default=>'localhost');
has 'Port' => (is=>"rw", default => '23456');
has 'Config'   => (is=>"rw"); #if has config can auto select where things must be done
has 'Description' => (is=>"rw");
has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});

sub select(){
	my $self=shift;
	my $Nodes=shift;
	my $Node=shift;
	$self->Host($Node);
	$self->Port($Nodes->{$Node}->{port});
	$self->Username($Nodes->{$Node}->{username});
	$self->Password($Nodes->{$Node}->{password});
	$self->Description($Nodes->{$Node}->{description});
	if(exists($Nodes->{$Node}->{deployer})){
		my $Deployer=$Nodes->{$Node}->{deployer};
		$self->Output->info("Deployer present: ".$Deployer);
		eval("use $Deployer"); #Not so elegant, i know, but for now i leave this like that.... because i'm lazy :)
		$self->Deployer( $Deployer->new( Node => $self ));
	}  else {
		$self->Output->info("Deployer not present :(");
	}
$self->Output->debug("Selected node: ".$self->Host);

	return $self;
}

sub customSelect() {
	my $self=shift;
	my $field=shift;
	my $custom=shift;
	my $Nodes=$self->Config->Nodes;
	foreach my $Node (keys (%{$Nodes} ) ){
		if($Nodes->{$Node}->{$field} eq $custom){
			$self->select($Nodes,$Node);
		}
	}
		return $self;

}

sub selectFromType()
{
	my $self=shift;
	my $type=shift;
	my $Nodes=$self->Config->Nodes;
	foreach my $Node (keys (%{$Nodes} ) ){
		if($Nodes->{$Node}->{type} eq $type){
			$self->select($Nodes,$Node);
		}
	}
	return $self;
}

sub selectFromHost()
{
	my $self=shift;
	my $H=shift;
	my $Nodes=$self->Config->Nodes;
	foreach my $Node (keys (%{$Nodes} ) ){
		if($Node eq $H){
			$self->select($Nodes,$Node);

		}
	}
	return $self;

}

sub selectFromDescription()
{
	my $self=shift;
	my $H=shift;
	my $Nodes=$self->Config->Nodes;
	foreach my $Node (keys (%{$Nodes} ) ){
		next if !$Nodes->{$Node}->{description};
		if($Nodes->{$Node}->{description} eq $H){
			$self->select($Nodes,$Node);

		}
	}
		return $self;

}

sub deploy(){
	my $self=shift;
	if($self->Deployer){
			$self->Deployer->deploy();

			} else {
				$self->Output->warn("Deployer not configured");
			}
	return $self;
}

1;