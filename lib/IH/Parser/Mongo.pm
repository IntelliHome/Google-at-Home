package IH::Parser::Mongo;

use Moose;
extends 'IH::Parser::Base';

use Search::GIN::Query::Class;
use Search::GIN::Query::Manual;
use IH::Schema::Mongo::Trigger;
use IH::Schema::Mongo::Task;
use IH::Parser::Mongo::DB;
use IH::Plugin::Base;
use Mongoose;

has 'Node' => ( is => "rw" );

sub prepare {

    my $self = shift;
    Mongoose->db(
        host    => $self->Config->DBConfiguration->{'db_dsn'},
        db_name => $self->Config->DBConfiguration->{'db_name'}
    );

}

sub detectTasks {
    my $self       = shift;
    my $Hypothesis = shift;
    my $hypo       = $Hypothesis->hypo;
    my @Tasks      = IH::Schema::Mongo::Task->query(
        { node => { host => $self->Node->Host }, status => 1 } )->all;
    if ( scalar @Tasks > 0 ) {
        caller->Output->info( "Ci sono " . scalar(@Tasks) . " task aperti" );
        foreach my $Task (@Tasks) {

        }

        ##XXX:
        ## Se i task ci sono, vengono processati perchè si suppone questa submission dell'utente sia una parziale risposta
        ## Dunque, si riempie i dati del task precedente,
        ## così l'altro thread può terminare la richiesta e quindi la risposta (se eventualmente genera altri task, ci sarà un motivo)
        ## Si controllano comandi di tipologia di annullamento, in tal caso si pone il task in deletion così il thread si chiude.
    }
    else {
        caller->Output->info( "nessun task per " . $self->Node->Host );

    }
}

sub detectTriggers {
    my $self       = shift;
    my $Hypothesis = shift;
    my $hypo       = $Hypothesis->hypo;

    my @Triggers = IH::Schema::Mongo::Trigger->all;

    foreach my $item (@Triggers) {

        #Every Trigger cycled here.
        #
        if ( $item->compile($hypo) ) {
            my $r = $item->regex;
            $hypo =~ s/$r//g;    #removes the trigger
                                 #Checking the trigger needs.

            foreach my $need ( $item->needs->all ) {
                if ( $need->compile($hypo) ) {

                    $hypo =~ s/$r//g;    #removes the trigger
                }
                elsif ( $need->forced ) {

                    #ASkUsers
                    my @Q = $need->questions->all;
                    caller->Output->info(
                        $Q[ int( rand( scalar @Q ) ) ]->ask() );
                    ###XXX:
                    ### QUI CREO IL TASK E ASPETTO UN CAMBIAMENTO DI STATO.

                }
            }

        }
        else {
            print "No match for trigger.\n";
        }

    }
}

sub parse {
    my $self       = shift;
    my $caller     = caller;
    my @hypotheses = @_;

    return 0 if scalar @hypotheses < 0;

    foreach my $hypo (@hypotheses) {

        my $Hypothesis = IH::Parser::Mongo::DB->newHypo( hypo => $hypo );

        $self->detectTasks($Hypothesis);

        $self->detectTriggers($Hypothesis);

    }

}
1;
