use Test::More;
use IH::Google::TTS;
my $TTS = IH::Google::TTS->new();

ok( defined($TTS) && $TTS->isa("IH::Google::TTS"),
    'IH::Google::TTS initialization ' );
$TTS->text('Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud');
$TTS->tts();
ok( @{$TTS->Sentences()}!=0, 'IH::Google::TTS output '.@{$TTS->Sentences}.' sentences ');
$TTS->tts('Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud');
ok( @{$TTS->Sentences()}!=0, 'IH::Google::TTS output '.@{$TTS->Sentences}.' sentences ');
done_testing;