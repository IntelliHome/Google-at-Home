package IH::Node;
use Moo;
has 'Deployer' => (is=>"rw");
has 'Username' => (is=>"rw");
has 'Password' => (is=>"rw");
has 'Host' => (is=>"rw", default=>'localhost');
has 'Port' => (is=>"rw", default => '23456');
has 'Config'   => (is=>"rw"); #if has config can auto select where things must be done
has 'Description' => (is=>"rw");

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
		$self->Deployer( sub { return $Nodes->{$Node}->{deployer}->new( Node => $self ) } );
	} 
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
		if($Nodes->{$Node}->{description} eq $H){
			$self->select($Nodes,$Node);

		}
	}
		return $self;

}

sub deploy(){
	my $self=shift;
	$self->Deployer->deploy();
	return $self;
}

1;