package IH::Deployer::Debian;
use Moo;
use Net::SSH::Any;

extends 'IH::Deployer::Base';

sub deploy(){
	my $self=shift;

my $ssh = Net::SSH::Any->new($self->Node->Host, user => $self->Node->Username, password => $self->Node->Password);
 
#my @out = $ssh->capture(cat => "/etc/passwd");
#my ($out, $err) = $ssh->capture2("ls -l /");
$ssh->system("foo");

if($ssh->system('apt-get install --force-yes libparallel-iterator-perl libmodule-depends-perl cpanminus git libfile-homedir-perl libmoo-perl libmoose-perl liblog-any-adapter-perl liblog-any-perl build-essential libdpkg-perl libapt-pkg-perl')){
	$self->Output->info("git, cpanminus and few deps are correctly installed");
	$self->Output->info("Cloning from repository");


}
 
#my $sftp = $ssh->sftp; # returns Net::SFTP::Foreign object
#$sftp->put($local_path, $remote_path);


}
1;

__END__

git clone https://github.com/mudler/IntelliHome.git
cd IntelliHome/
cpanm Debian::Apt::PM
perl -MDebian::Apt::PM -MModule::Depends -le '$apm=Debian::Apt::PM->new();$md=Module::Depends->new->dist_dir(".")->find_modules; %r=(%{$md->requires},%{$md->build_requires}); while (($m, $v) = each %r) { $f=$apm->find($m, $v); print $f->{"min"}->{"package"} if $f->{"min"}  }' | sort | uniq | xargs echo apt-get install