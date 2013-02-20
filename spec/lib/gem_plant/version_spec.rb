# encoding: utf-8


describe GemPlant do

  let(:klass) { GemPlant }

  context "definition" do
    subject { klass }
    it { should be_const_defined :VERSION }
  end

  context "::VERSION" do
    subject { GemPlant::VERSION }
    it { should be_instance_of String }
    it { should =~ /\d+\.\d+\.\d+(\.\w+)?/ }
  end

end
