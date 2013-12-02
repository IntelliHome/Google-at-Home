package IH::Parser;
use Moose;
use Search::GIN::Query::Class;
use Search::GIN::Query::Manual;
use IH::Schema::Trigger;
use IH::Schema::Task;
use IH::DB;
with 'MooseX::Object::Pluggable';
has 'Node' => ( is => "rw" );

sub parse() {
    my $self       = shift;
    my $caller     = caller();
    my @hypotheses = @_;

    return 0 if scalar @hypotheses < 0;

    foreach my $hypo (@hypotheses) {

        my @Tasks = IH::Schema::Task->query(
            { node => { host => $self->Node->Host } } )->all;
        if ( scalar @Tasks > 0 ) {
            $caller->Output->info(
                "Ci sono " . scalar(@Tasks) . " task aperti" );
            foreach my $Task (@Tasks) {

            }

            ##XXX:
            ## Se i task ci sono, vengono processati perchè si suppone questa submission dell'utente sia una parziale risposta
            ## Dunque, si riempie i dati del task precedente,
            ## così l'altro thread può terminare la richiesta e quindi la risposta (se eventualmente genera altri task, ci sarà un motivo)
            ## Si controllano comandi di tipologia di annullamento, in tal caso si pone il task in deletion così il thread si chiude.
        }
        else {
            $caller->Output->info( "nessun task per " . $self->Node->Host );

        }

        my @Triggers = IH::Schema::Trigger->all;

        foreach my $item (@Triggers) {

            #Every Trigger cycled here.
            #
            my $r = $item->regex();
            if ( $hypo =~ /$r/i ) {

                $hypo =~ s/$r//g;    #removes the trigger

                if ( scalar $item->needs->size > 0 ) {
                    $caller->Output->info(
                        "ci sono più informazioni necessarie.");

#In caso di non detect: cicla finche non satisfy(), e riempie le informazioni sul task, altrimenti il task non viene creato

                    my @Needs = $item->needs->all;
                    foreach my $Need (@Needs) {
                        my $re = $Need->regex();
                        if ( $hypo =~ /$re/ ) {
                            $Need->hypo($hypo);
                            $Need->compile();
                            $hypo =~ s/$re//g;    # and .. removes the trigger

                        }
                        elsif ( $Need->forced ) {

                            #ASkUsers
                            my @Q = $Need->questions->all;
                            $caller->Output->info(
                                $Q[ int( rand( scalar @Q ) ) ]->ask() );
                            ###XXX:
                            ### QUI CREO IL TASK E ASPETTO UN CAMBIAMENTO DI STATO.

                        }

                    }

                }
            }
            else {
                print "No match for trigger.\n";
            }

        }

    }

}
1;
