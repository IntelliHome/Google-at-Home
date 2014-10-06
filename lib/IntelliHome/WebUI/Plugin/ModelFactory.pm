package IntelliHome::WebUI::Plugin::ModelFactory;

use Mojo::Base 'Mojolicious::Plugin';
use IntelliHome::WebUI::Plugin::RPC;
use IntelliHome::WebUI::Model::Tile;
use IntelliHome::WebUI::Model::Room;
use IntelliHome::WebUI::Model::Node;
use constant DEBUG => $ENV{DEBUG} || 0;

sub register {
    my ( $self, $app, $conf ) = @_;
    $app->helper(
        build_tiles => sub {
            my @tiles;
            warn "build_tiles() called \n" if DEBUG;
            push( @tiles, IntelliHome::WebUI::Model::Tile->new( %{$_} ) )
                for shift->app->rpc_call_blocking( "ask", "rpc_gpio_data" );
            return @tiles;
        }
    );
    $app->helper(
        build_rooms => sub {
            my @rooms;
            warn "build_rooms() called \n" if DEBUG;
            push( @rooms, IntelliHome::WebUI::Model::Room->new( %{$_} ) )
                for shift->app->rpc_call_blocking( "ask", "rpc_get_rooms" );
            return @rooms;

            #return [shift->app->rpc_call_blocking("ask","get_rooms")];
        }
    );
    $app->helper(
        build_nodes => sub {
            my @nodes;
            push( @nodes, IntelliHome::WebUI::Model::Node->new( %{$_} ) )
                for shift->app->rpc_call_blocking( "ask", "rpc_get_nodes" );
            return @nodes;

            #return [shift->app->rpc_call_blocking("ask","get_nodes")];
        }
    );

    $app->helper(
        build_new_node => sub {
            warn "build_new_node() called \n" if DEBUG;

            return
                shift->app->rpc_call_blocking( "db", "rpc_add_node", shift,
                shift );

            #return [shift->app->rpc_call_blocking("ask","get_nodes")];
        }
    );

    $app->helper(
        build_new_tag => sub {
            warn "build_new_tag() called \n" if DEBUG;

            return
                shift->app->rpc_call_blocking( "db", "rpc_add_tag", shift,
                shift );

            #return [shift->app->rpc_call_blocking("ask","get_nodes")];
        }
    );

    $app->helper(
        build_new_gpio => sub {
            warn "build_new_gpio() called \n" if DEBUG;

            return
                shift->app->rpc_call_blocking( "db", "rpc_add_gpio", shift,
                shift );
        }
    );
    $app->helper(
        build_new_pin => sub {
            warn "build_new_pin() called \n" if DEBUG;

            return
                shift->app->rpc_call_blocking( "db", "rpc_add_pin", shift,
                shift );
        }
    );
    $app->helper(
        build_new_room => sub {
            warn "build_new_room() called \n" if DEBUG;

            my $room
                = $_[0]
                ->app->rpc_call_blocking( "db", "rpc_add_room", $_[1] );
            push(
                @{ $_[0]->app->rooms },
                IntelliHome::WebUI::Model::Room->new( %{$room} )
            );
            return $room;
        }
    );
    $app->helper(
        delete_entity => sub {
            warn "delete_entity() called \n" if DEBUG;

            return
                shift->app->rpc_call_blocking( "db", "rpc_delete", shift,
                shift );
        }
    );
    $app->helper(
        deserialize_form_data => sub {
            warn "deserialize_form_data() called \n" if DEBUG;

            map { ( $_->{name} =~ /new-(.*?)$/ )[0] => $_->{value} }
                @{ decode_json $_[1] };
        }
    );

}

1;

__END__

=encoding utf-8

=head1 NAME

IntelliHome::WebUI::Plugin::ModelFactory - ModelFactory plugin for mojolicious web application

=head1 SYNOPSIS

    build_tiles;
    #...
    build_rooms;
    #...
    build_nodes;

=head1 DESCRIPTION

This Mojolicious plugin allow to build internal structures used into the web application

=head1 METHODS

=head2 build_rooms

returns an array ref containing the rooms object L<IntelliHome::WebUI::Model::Room>

    build_rooms

=head2 build_tiles

returns an array of L<IntelliHome::WebUI::Model::Tile> objects

    build_tiles;

=head2 build_nodes

returns an array of L<IntelliHome::WebUI::Model::Node> objects

    build_nodes;

=head1 AUTHOR

skullbocks E<lt>dgikiller@gmail.comtE<gt>

=head1 COPYRIGHT

Copyright 2014- skullbocks

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO
L<IntelliHome::WebUI::Plugin::ModelFactory>, L<IntelliHome::IntelliHomeWebUI>, L<IntelliHome::Schema::SQLite::Schema::Result::Room>, L<IntelliHome::Schema::SQLite::Schema::Result::Room>


=cut
