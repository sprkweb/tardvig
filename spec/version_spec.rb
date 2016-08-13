RSpec.describe 'Version' do
  it 'has three parts divided by dot' do
    expect(Tardvig::VERSION.split('.').size).to eq(3)
  end

  it 'consists of numbers' do
    Tardvig::VERSION.split('.').each do |part|
      expect(part).to eq(part.to_i.to_s)
    end
  end
end
