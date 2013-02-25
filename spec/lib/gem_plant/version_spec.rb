# encoding: utf-8


describe GemPlant do

  context "definition" do
    subject { described_class }
    it { should be_const_defined :VERSION }
  end

  context "::VERSION" do
    subject { described_class::VERSION }
    it { should be_instance_of String }
    it { should =~ /\d+\.\d+\.\d+(\.\w+)?/ }
  end

end
