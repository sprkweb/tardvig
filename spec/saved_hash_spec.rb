RSpec.describe Tardvig::SavedHash do
  let(:hash) { described_class.new }
  let(:io) { StringIO.new }

  it 'is hash' do
    expect(described_class.superclass).to be(Hash)
  end

  describe '#save' do
    it 'saves itself to the given IO via YAML' do
      hash['key'] = 'value'
      hash.save io
      expect(YAML.load(io.string)).to include('key' => 'value')
    end

    it 'saves itself to the given path if a string is given' do
      hash['key'] = 'value'
      filename = hash.hash.to_s
      hash.save filename
      expect(YAML.load(File.read(filename))).to include('key' => 'value')
      File.unlink filename
    end

    it 'raises error if the argument type is invalid' do
      expect { hash.save 1 }.to raise_error(ArgumentError)
    end

    it 'triggers an event with itself as an argument' do
      expect(hash).to receive(:trigger).with(:save, hash)
      hash.save io
    end

    it 'triggers an event before saving' do
      output = spy
      hash.on :save do
        expect(output).not_to have_received(:write)
      end
      hash.save output
    end
  end

  let(:saved_data) do
    a_hash = described_class.new
    a_hash['valid'] = true
    a_hash.save io
    saved_data = double
    allow(saved_data).to receive(:read) { io.string }
    allow(saved_data).to receive(:write)
    saved_data
  end

  describe '#load' do
    it 'loads YAML data from the given IO to itself' do
      hash.load saved_data
      expect(hash['valid']).to be true
    end

    it 'does not delete old data' do
      hash['one'] = 1
      hash.load saved_data
      expect(hash['one']).to eq(1)
    end

    it 'overrides old data' do
      hash['valid'] = false
      hash.load saved_data
      expect(hash['valid']).to be true
    end

    it 'loads data from the given path if a string is given' do
      hash['valid'] = true
      filename = hash.hash.to_s
      hash.save filename
      another_hash = described_class.new
      another_hash.load filename
      expect(another_hash['valid']).to be true
      File.unlink filename
    end

    it 'raises error if the argument type is invalid' do
      expect { hash.load 1 }.to raise_error(ArgumentError)
    end

    it 'triggers an event with itself as an argument' do
      expect(hash).to receive(:trigger).with(:load, hash)
      hash.load saved_data
    end

    it 'triggers an event after loading' do
      hash.on(:load) do
        expect(hash['valid']).to be true
      end
      hash.load saved_data
    end
  end

  describe 'new' do
    class BrokenSavedHash < described_class
      def load(*_args)
        raise IOError
      end
    end

    it 'creates an instance and loads data if it is given' do
      expect { BrokenSavedHash.new saved_data }.to raise_error(IOError)
    end
  end
end
