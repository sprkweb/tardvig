RSpec.describe Tardvig::Act do
  class MyAct < Tardvig::Act
    act_type :text
    subject 'mycontent'
  end

  let(:io) { double }
  let(:act) { MyAct.new io: io }

  describe '#call' do
    it 'notifies your display' do
      expect(act).to receive(:notify_display)
      act.call
    end
  end

  describe '#notify_display' do
    it 'sends message to your display on startup' do
      expect(io).to(
        receive(:happen).with(:act_start, type: :text, subject: 'mycontent')
      )
      act.call
    end

    class AnotherAct < MyAct
      def display_format
        'formatted'
      end
    end

    it 'sends display_format as a subject' do
      expect(io).to(
        receive(:happen).with(:act_start, type: :text, subject: 'formatted')
      )
      AnotherAct.call io: io
    end

    class YetAnotherAct < AnotherAct
      def notify_display
        io.puts 'foo'
      end
    end

    it 'can be redefined' do
      expect(io).to receive(:puts).with('foo')
      YetAnotherAct.call io: io
    end
  end

  let(:act_class) { Class.new(Tardvig::Act) }
  let(:subject) { double }

  it 'stores your object as a subject of your act' do
    act_class.subject subject
    expect(act_class.subject).to be(subject)
  end

  describe 'act_type' do
    it 'stores your act type' do
      act_class.act_type :mytype
      expect(act_class.act_type).to eq(:mytype)
    end

    it 'inherits act type' do
      act_class.act_type :mytype
      inherited_act_class = Class.new(act_class)
      expect(inherited_act_class.act_type).to eq(act_class.act_type)
    end
  end
end
