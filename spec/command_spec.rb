RSpec.describe Tardvig::Command do
  class Add < Tardvig::Command
    attr_reader :result

    def process
      @result = foo + bar
    end
  end

  example do
    command_instance = Add.new
    command_instance.call foo: 2, bar: 2
    expect(command_instance.result).to eq(4)
  end

  describe 'process' do
    it 'raises exception if it is not defined' do
      expect { described_class.call }.to raise_error(NoMethodError)
    end
  end

  describe 'new' do
    it 'recieves params' do
      mycommand = Tardvig::Command.new foo: 'bar', baz: 123
      expect(mycommand.foo).to eq('bar')
      expect(mycommand.baz).to eq(123)
    end

    it 'doesn\'t execute its process' do
      command = Add.new foo: 1, bar: 2
      expect(command.result.nil?).to be true
    end
  end

  describe '#call' do
    let(:called_command) do
      Add.new.call(foo: 321, bar: 123)
    end

    it 'returns itself' do
      expect(called_command).to be_a(Add)
    end

    it 'recieves params' do
      expect(called_command.foo).to eq(321)
      expect(called_command.bar).to eq(123)
    end

    it 'executes its process' do
      expect(called_command.result).to eq(444)
    end

    it 'overrides params' do
      mycommand = Add.new foo: 1, bar: 1
      expect(mycommand.foo).to eq(1)
      mycommand.call foo: 321
      expect(mycommand.foo).to eq(321)
    end
  end

  describe '#execute' do
    class ExtendedCommand < Tardvig::Command
      def before
      end

      def process
      end

      def after
      end

      def execute
        before
        process
        after
      end
    end

    it 'can be redefined to change the order of the execution' do
      mycommand = ExtendedCommand.new
      expect(mycommand).to receive(:before).ordered
      expect(mycommand).to receive(:process).ordered
      expect(mycommand).to receive(:after).ordered
      mycommand.call
    end
  end
end
