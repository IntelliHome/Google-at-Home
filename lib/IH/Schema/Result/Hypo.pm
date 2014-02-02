package IH::Schema::Result::Hypo;
use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->table('hypos');
__PACKAGE__->add_columns(qw/ hypoid hypo start_time/);
__PACKAGE__->set_primary_key('hypoid');
#__PACKAGE__->belongs_to('artist' => 'MyDatabase::Main::Result::Artist');
__PACKAGE__->has_many('tasks' => 'IH::Schema::Result::Task');
__PACKAGE__->has_many('needs' => 'IH::Schema::Result::Need');

1;