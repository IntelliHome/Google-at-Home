use Test::More;
use IntelliHome::Google::TTS;
my $TTS = IntelliHome::Google::TTS->new();

ok( defined($TTS) && $TTS->isa("IntelliHome::Google::TTS"),
    'IntelliHome::Google::TTS initialization ' );
$TTS->text('Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud');
$TTS->tts();
ok( @{$TTS->Sentences()}!=0, 'IntelliHome::Google::TTS output '.@{$TTS->Sentences}.' sentences ');
$TTS->tts('Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud');
ok( @{$TTS->Sentences()}!=0, 'IntelliHome::Google::TTS output '.@{$TTS->Sentences}.' sentences ');
done_testing;