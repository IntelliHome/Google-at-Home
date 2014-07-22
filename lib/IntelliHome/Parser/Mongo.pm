package IntelliHome::Parser::Mongo;

=head1 NAME

IntelliHome::Parser::Mongo - Mongo parser for IntelliHome

=head1 DESCRIPTION

This object implement a Mongo parser for IntelliHome, dispatching the text trigger to the appropriate plugin

=head1 METHODS

IntelliHome::Parser::Mongo overrides the IntelliHome::Parser::Base detectTriggers() and parse() functions

=head1 SEE ALSO

L<IntelliHome::Parser::SQLite>, L<IntelliHome::Parser::Base>

=cut


use Moo;
extends 'IntelliHome::Parser::Base';
use IntelliHome::Schema::Mongo::Trigger;
use IntelliHome::Schema::Mongo::Task;
use IntelliHome::Parser::DB::Mongo;
use Mongoose;
use Deeme;
use Deeme::Backend::Mango;

has 'Backend' => ( is => "rw" );
has 'event' => (
    is      => "rw",
    default => sub {
        my $self = shift;
        return Deeme->new(
            backend => Deeme::Backend::Mango->new(
                host     => $self->Config->DBConfiguration->{'db_dsn'},
                database => $self->Config->DBConfiguration->{'db_name'}
            )
        );
    }
);

sub BUILD {
    my $self = shift;
    Mongoose->db(
        host    => $self->Config->DBConfiguration->{'db_dsn'},
        db_name => $self->Config->DBConfiguration->{'db_name'}
    );
    $self->Backend(
        IntelliHome::Parser::DB::Mongo->instance( Config => $self->Config ) );
}

sub detectTasks {
    my $self       = shift;
    my $Hypothesis = shift;
    my $hypo       = $Hypothesis->hypo;
    my @Tasks      = IntelliHome::Schema::Mongo::Task->query(
        { node => { host => $self->Node->Host }, status => 1 } )->all;
    if ( scalar @Tasks > 0 ) {

        # $self->Output->info( "Ci sono " . scalar(@Tasks) . " task aperti" );
        foreach my $Task (@Tasks) {

        }

        ##XXX:
        ## Se i task ci sono, vengono processati perchè si suppone questa submission dell'utente sia una parziale risposta
        ## Dunque, si riempie i dati del task precedente,
        ## così l'altro thread può terminare la richiesta e quindi la risposta (se eventualmente genera altri task, ci sarà un motivo)
        ## Si controllano comandi di tipologia di annullamento, in tal caso si pone il task in deletion così il thread si chiude.
   # }
     #else {
        #   $self->Output->info( "nessun task per " . $self->Node->Host );

    }
}

sub detectTriggers {
    my $self       = shift;
    my $Hypothesis = shift;
    my $hypo       = $Hypothesis->hypo;

    my @Triggers = $self->Backend->getTriggers(
        $self->Config->DBConfiguration->{'language'} );
    my $Satisfied = 0;
    foreach my $item (@Triggers) {

        #Every Trigger cycled here.
        #
        if ( $item->compile($hypo) and $item->satisfy ) {

            $Satisfied++
                if $self->run_plugin( $item->plugin, $item->plugin_method,
                $item );

            # my $r = $item->regex;
            #  $hypo =~ s/$r//g;    #removes the trigger
            #Checking the trigger needs.

            # foreach my $need ( $item->needs->all ) {
            #     if ( $need->compile($hypo) ) {

            #         $hypo =~ s/$r//g;    #removes the trigger
            #     }
            #     elsif ( $need->forced ) {

            #         #ASkUsers
            #         my @Q = $need->questions->all;
            #         caller->Output->info(
            #             $Q[ int( rand( scalar @Q ) ) ]->ask() );
            #         ###XXX:
            #         ### QUI CREO IL TASK E ASPETTO UN CAMBIAMENTO DI STATO.

            #     }
            # }

        }
        else {
            #   print "No match for trigger.\n";

        }

    }
    $self->Output->debug(
        "A total of $Satisfied plugins satisfied the request");
    return $Satisfied;
}

sub parse {
    my $self       = shift;
    my @hypotheses = @_;
    return 0 if scalar @hypotheses < 0;
    for (@hypotheses) {
        my $Hypothesis = $self->Backend->newHypo( { hypo => $_ } );
        $self->detectTasks($Hypothesis);
        last if $self->detectTriggers($Hypothesis) != 0;
    }
}
1;
