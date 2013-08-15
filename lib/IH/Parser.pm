package IH::Parser;
use Moose;
use Search::GIN::Query::Class;
use Search::GIN::Query::Manual;

with 'MooseX::Object::Pluggable';
has 'Node' => ( is => "rw" );

sub parse() {
    my $self       = shift;
    my $caller     = caller();
    my @hypotheses = @_;

    return 0 if scalar @hypotheses < 0;

    foreach my $hypo (@hypotheses) {
        my $DB = IH::DB->connect("./config/kiokudb.yml");

        my $results = $DB->class_search("IH::Schema::Task");

        my $query = Search::GIN::Query::Manual->new(
            values => { Host => $self->Node->Host }, );

        my @Tasks = $DB->search($query)->all;

        if ( scalar @Tasks > 0 ) {
            ##XXX:
            ##Se i task ci sono, vengono processati perchè si suppone questa submission dell'utente sia una parziale risposta
            ## Dunque, si riempie i dati del task precedente, così l'altro thread può terminare la richiesta e quindi la risposta (se eventualmente genera altri task, ci sarà un motivo)
#Si controllano comandi di tipologia di annullamento, in tal caso si pone il task in deletion così il thread si chiude.
        }

        $results = $DB->class_search("IH::Schema::Trigger");

        while ( my $block = $results->next ) {
            foreach my $item ( @{$block} ) {

                #Every Trigger cycled here.
                #
                my $r = $item->regex();
                if ( $hypo =~ /$r/i ) {

                    $hypo =~ s/$r//g;    #removes the trigger

                    if ( scalar $item->needs->size > 0 ) {
                        $caller->Output->info(
                            "ci sono più informazioni necessarie.");

#In caso di non detect: cicla finche non satisfy(), e riempie le informazioni sul task, altrimenti il task non viene creato

                        my @Needs = $item->needs->members;
                        foreach my $Need (@Needs) {
                            my $re = $Need->regex();
                            if ( $hypo =~ /$re/ ) {
                                $Need->hypo($hypo);
                                $Need->compile();
                                $hypo
                                    =~ s/$re//g;  # and .. removes the trigger

                            }
                            elsif ( $Need->forced ) {

                                #ASkUsers
                                my @Q = $Need->questions->members;
                                $caller->Output->info(
                                    $Q[ int( rand( scalar @Q ) ) ]->ask() );
                                ###XXX:
                                ### QUI CREO IL TASK E ASPETTO UN CAMBIAMENTO DI STATO.

                            }

                        }

                    }
                }
                else {
                    #No match for trigger.
                }
            }
        }

    }

}
1;