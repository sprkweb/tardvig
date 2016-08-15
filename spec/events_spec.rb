RSpec.describe Tardvig::Events do
  let :extended_obj do
    Object.new.extend(Tardvig::Events)
  end

  describe '#on' do
    it 'can bind event listeners' do
      listener = proc {}
      extended_obj.on :my_event, &listener
      expect(extended_obj.listeners(:my_event)).to eq([listener])
    end

    it 'can bind listeners to many events' do
      listener = proc {}
      listener2 = proc {}
      extended_obj.on :my_event, &listener
      extended_obj.on :another_event, &listener2
      expect(extended_obj.listeners(:my_event)).to eq([listener])
      expect(extended_obj.listeners(:another_event)).to eq([listener2])
    end

    it 'can bind many listeners to an event' do
      listener = proc {}
      listener2 = proc {}
      extended_obj.on :my_event, &listener
      extended_obj.on :my_event, &listener2
      expect(extended_obj.listeners(:my_event)).to eq([listener, listener2])
    end
  end

  describe '#remove_listener' do
    it 'unbinds given listener' do
      listener = proc {}
      extended_obj.on :my_event, &listener
      extended_obj.remove_listener :my_event, listener
      expect(extended_obj.listeners(:my_event)).to eq([])
    end

    it 'unbinds only given listener' do
      listeners = [proc {}, proc {}]
      extended_obj.on :my_event, &listeners[0]
      extended_obj.on :my_event, &listeners[1]
      extended_obj.remove_listener :my_event, listeners[0]
      expect(extended_obj.listeners(:my_event)).to eq([listeners[1]])
    end

    it 'unbinds given listener only from the given event' do
      listener = proc {}
      extended_obj.on :my_event, &listener
      extended_obj.on :another_event, &listener
      extended_obj.remove_listener :my_event, listener
      expect(extended_obj.listeners(:another_event)).to eq([listener])
    end

    it 'unbinds all event listeners when there is no listener given' do
      listeners = [proc {}, proc {}]
      extended_obj.on :my_event, &listeners[0]
      extended_obj.on :my_event, &listeners[1]
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
      listener = proc {}
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
end
