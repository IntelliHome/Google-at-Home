package IntelliHome::Parser::SQLite;

=head1 NAME

IntelliHome::Parser::SQLite - SQLite parser for IntelliHome

=head1 DESCRIPTION

This object implement a SQLite parser for IntelliHome, dispatching the text trigger to the appropriate plugin

=head1 METHODS

IntelliHome::Parser::SQLite overrides the IntelliHome::Parser::Base detectTriggers() and parse() functions

=head1 SEE ALSO

L<IntelliHome::Parser::Mongo>, L<IntelliHome::Parser::Base>

=cut


use Moo;
extends 'IntelliHome::Parser::Base';
use IntelliHome::Parser::DB::SQLite;
use IntelliHome::Schema::SQLite::Schema;
use Deeme::Backend::SQLite;

has 'Backend' => ( is => "rw" );
has 'event' => (
    is      => "rw",
    default => sub {
        my $self = shift;
        return IntelliHome::EventEmitter->new(
            backend => Deeme::Backend::SQLite->new(
                database => $self->Config->DBConfiguration->{'db_name'}
            ),
            IntelliHome=>$self,
            app=> $self
        );
    }
);

sub BUILD {
    my $self = shift;
    $self->Backend(
        IntelliHome::Parser::DB::SQLite->new( Config => $self->Config ) );
}

#TODO substitute Mongo task with another kind of object.
# sub detectTasks {
#     my $self       = shift;
#     my $Hypothesis = shift;
#     my $hypo       = $Hypothesis->hypo;
#     my @Tasks      = IntelliHome::Schema::Mongo::Task->query(
#         { node => { host => $self->Node->Host }, status => 1 } )->all;
#     if ( scalar @Tasks > 0 ) {

#         # $self->Output->info( "Ci sono " . scalar(@Tasks) . " task aperti" );
#         foreach my $Task (@Tasks) {

#         }

#         ##XXX:
#         ## Se i task ci sono, vengono processati perchè si suppone questa submission dell'utente sia una parziale risposta
#         ## Dunque, si riempie i dati del task precedente,
#         ## così l'altro thread può terminare la richiesta e quindi la risposta (se eventualmente genera altri task, ci sarà un motivo)
#         ## Si controllano comandi di tipologia di annullamento, in tal caso si pone il task in deletion così il thread si chiude.
#     }
#     else {
#         #   $self->Output->info( "nessun task per " . $self->Node->Host );

#     }
# }

sub detectTriggers {
    my $self = shift;
    my $hypo = shift;

    my ( $t, @args ) = split( " ", $hypo );
    my $rs        = $self->Backend->search_trigger($t);
    my $Satisfied = 0;
    while ( my $trigger = $rs->next ) {
        if ( @{ $trigger->{result} } =
            join( " ", @args ) =~ /$trigger->arguments/i )
        {
            $Satisfied++
              if $self->run_plugin( $trigger->command->plugin,
                $trigger->command->plugin_method, $trigger );

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

      #  }
       # else {
            #   print "No match for trigger.\n";

        }

    }
    $self->Output->debug("A total of $Satisfied plugins satisfied the request");
    return $Satisfied;
}

sub parse {
    my $self       = shift;
    my $caller     = caller;
    my @hypotheses = @_;

    return 0 if scalar @hypotheses < 0;

    foreach my $hypo (@hypotheses) {

        last if $self->detectTriggers($hypo) != 0;

    }

}
1;
