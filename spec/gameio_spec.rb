RSpec.describe Tardvig::GameIO do
  let(:subject) { described_class.new }

  it 'uses events as communication format' do
    expect(subject).to be_a(Tardvig::Events)
  end
end
