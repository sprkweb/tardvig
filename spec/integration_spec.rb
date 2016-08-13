RSpec.describe 'Example of integration' do
  # Act types

  class TextAct < Tardvig::Act
    act_type :text
  end

  class QuestionAct < Tardvig::Act
    act_type :question

    def execute
      bind_listeners
      super
    end

    def bind_listeners
      answer_listener = proc do |answer|
        if answer == self.class.subject[:right_answer]
          on_right_answer
          io.remove_listener :answer, answer_listener
        else
          notify_display
        end
      end
      io.on :answer, &answer_listener
    end

    def display_format
      self.class.subject[:question]
    end

    def on_right_answer
    end
  end

  # Acts

  class Introduction < TextAct
    subject 'You need to do everything I will ask you for.'

    def process
      Meowing.call io: io
    end
  end

  class Meowing < QuestionAct
    subject question: 'Say "Meow!"', right_answer: 'Meow!'

    def on_right_answer
      io.happen :gameover
    end
  end

  # Example of GameIO realization which converts events to console IO.
  class Display < Tardvig::GameIO
    def initialize(input, output)
      @input = input
      @output = output
      bind_listeners
    end

    private

    def bind_listeners
      on :act_start, &method(:act_started)
      on :gameover, &method(:gameover)
    end

    def act_started(act)
      case act[:type]
      when :text
        @output.puts act[:subject]
      when :question
        @output.puts act[:subject]
        happen :answer, @input.gets
      end
    end

    def gameover(_)
      @output.puts 'Game over!'
    end
  end

  # You can imagine this is $stdin
  let(:input) { double }
  # and this is $stdout instead so this is a console game
  let(:output) { StringIO.new }
  let(:io) { Display.new input, output }

  it 'is playable' do
    expect(input).to receive(:gets).and_return('Meow!')
    Introduction.call io: io
    expect(output.string).to(
      eq("You need to do everything I will ask you for.\n" \
        "Say \"Meow!\"\n" \
        "Game over!\n")
    )
  end

  it 'asks again if the answer is not right' do
    expect(input).to(
      receive(:gets).exactly(3).times.and_return('Hello!', 'Moo!', 'Meow!')
    )
    Introduction.call io: io
    expect(output.string).to(
      eq("You need to do everything I will ask you for.\n" +
        "Say \"Meow!\"\n" * 3 +
        "Game over!\n")
    )
  end
end
