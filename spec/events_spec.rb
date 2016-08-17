RSpec.describe Tardvig::Events do
  let :extended_obj do
    Object.new.extend(Tardvig::Events)
  end

  let(:listener) { proc {} }
  let(:listener2) { proc {} }

  describe '#on' do
    it 'can bind event listeners' do
      extended_obj.on :my_event, &listener
      expect(extended_obj.listeners(:my_event)).to eq([listener])
    end

    it 'can bind listeners to many events' do
      extended_obj.on :my_event, &listener
      extended_obj.on :another_event, &listener2
      expect(extended_obj.listeners(:my_event)).to eq([listener])
      expect(extended_obj.listeners(:another_event)).to eq([listener2])
    end

    it 'can bind many listeners to an event' do
      extended_obj.on :my_event, &listener
      extended_obj.on :my_event, &listener2
      expect(extended_obj.listeners(:my_event)).to eq([listener, listener2])
    end
  end

  describe '#remove_listener' do
    it 'unbinds given listener' do
      extended_obj.on :my_event, &listener
      extended_obj.remove_listener :my_event, listener
      expect(extended_obj.listeners(:my_event)).to eq([])
    end

    it 'unbinds only given listener' do
      extended_obj.on :my_event, &listener
      extended_obj.on :my_event, &listener2
      extended_obj.remove_listener :my_event, listener
      expect(extended_obj.listeners(:my_event)).to eq([listener2])
    end

    it 'unbinds given listener only from the given event' do
      extended_obj.on :my_event, &listener
      extended_obj.on :another_event, &listener
      extended_obj.remove_listener :my_event, listener
      expect(extended_obj.listeners(:another_event)).to eq([listener])
    end

    it 'unbinds all event listeners when there is no listener given' do
      extended_obj.on :my_event, &listener
      extended_obj.on :my_event, &listener2
      extended_obj.remove_listener :my_event
      expect(extended_obj.listeners(:my_event)).to eq([])
    end

    it 'unbinds listeners only from the given event ' \
      'when there is no listener given' do
      listener = proc {}
      extended_obj.on :another_event, &listener
      extended_obj.remove_listener :my_event
      expect(extended_obj.listeners(:another_event)).to eq([listener])
    end
  end

  describe '#happen' do
    it 'executes all the event listeners' do
      executed = []
      extended_obj.on(:my_event) { executed << 1 }
      extended_obj.on(:my_event) { executed << 2 }
      extended_obj.happen :my_event
      expect(executed).to eq([1, 2])
    end

    it 'do nothing when there is no listeners' do
      extended_obj.happen :my_event
    end

    it 'executes listeners only from the given event' do
      extended_obj.on :another_event, &listener
      expect(listener).to_not receive(:call)
      extended_obj.happen :my_event
    end

    it 'passes data as an argument' do
      my_data = Object.new
      extended_obj.on :my_event do |data|
        expect(data).to be(my_data)
      end
      extended_obj.happen :my_event, my_data
    end
  end

  describe '#on_first' do
    it 'binds listener which is executed only once' do
      extended_obj.on_first :event, &listener
      expect(listener).to receive(:call).once
      2.times { extended_obj.happen :event }
    end
  end
end
