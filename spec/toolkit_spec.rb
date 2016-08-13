RSpec.describe Tardvig::Toolkit do
  MyClass = Class.new

  class MyToolkit < Tardvig::Toolkit
    tool :mystring, 'mystring'
    tool :myobj, MyClass
    tool :myrandom do
      rand 1..999_999
    end
  end

  let(:toolkit) { MyToolkit.new }

  it 'just gives access to the tools which don\'t have to be initialized' do
    expect(toolkit.mystring).to eq('mystring')
  end

  it 'creates a new instance when the tool is a class' do
    expect(toolkit.myobj).to be_a(MyClass)
  end

  it 'creates an instance of the tool per toolkit' do
    expect(toolkit.myobj).to be(toolkit.myobj)
  end

  it 'gives result of the custom initialization as a tool' do
    expect(toolkit.myrandom).to be_a(Numeric)
  end

  it 'executes the custom initialization only once per toolkit' do
    expect(toolkit.myrandom).to eq(toolkit.myrandom)
  end

  class MyToolkit
    tool :mytoolkit do |toolkit|
      toolkit
    end
  end

  it 'gives access to itself when the call method is executed' do
    expect(toolkit.mytoolkit).to be(toolkit)
  end

  class MyToolkit
    tool :custom_tool do |_toolkit, params|
      params
    end
  end

  it 'gives access to the argument of the initialization method' do
    argument = double
    mytoolkit = MyToolkit.new argument
    expect(argument).to receive(:verify)
    mytoolkit.custom_tool.verify
  end
end
