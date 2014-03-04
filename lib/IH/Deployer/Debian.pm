package IH::Deployer::Debian;
use Moose;
use Net::SSH::Any;

extends 'IH::Deployer::Base';

sub deploy{
    return undef;
}

sub deploy_t {
    my $self = shift;

    my $ssh = Net::SSH::Any->new(
        $self->Node->Host,
        user     => $self->Node->Username,
        password => $self->Node->Password
    );

    #my @out = $ssh->capture(cat => "/etc/passwd");
    #my ($out, $err) = $ssh->capture2("ls -l /");
    $ssh->system("foo");

    if ($ssh->system(
            'apt-get install --force-yes sox libparallel-iterator-perl libmodule-depends-perl cpanminus git libfile-homedir-perl libmoo-perl libmoose-perl liblog-any-adapter-perl liblog-any-perl build-essential libdpkg-perl libapt-pkg-perl'
        )
        )
    {
        $self->Output->info(
            "git, cpanminus and few deps are correctly installed");
        $self->Output->info("Cloning from repository");

    }
    else {
        $self->Output->error( "Deploy failed on " . $self->Node->Host() );

        #we need report here
    }

    #my $sftp = $ssh->sftp; # returns Net::SFTP::Foreign object
    #$sftp->put($local_path, $remote_path);

}
1;

__END__

git clone https://github.com/mudler/IntelliHome.git
cd IntelliHome/
cpanm Module::CPANfile
cpanm --installdeps .
