# encoding: utf-8


require 'spec_helper'


describe GemPlant::CLI::GitHelper do

  context "definition" do
    subject { described_class }
    it { should be_kind_of Module }
    it { should_not be_kind_of Class }
  end

  before(:all) {
    class Dummy
      include GemPlant::CLI::GitHelper
    end
  }
  let(:dummy) { Dummy.new }
  subject { dummy }
  it { should respond_to :git }

  context "#git" do
    subject { dummy.git params }
    let(:params) { nil }
    let(:mock_git) { mock(GemPlant::CLI::Plugins::Git) }
    before { GemPlant::CLI::Plugins::Git.stub(:new).and_return(mock_git) }
    it "should return instance of GemPlant::CLI::Plugins::Git" do
      should == mock_git
    end
    context "should call GemPlant::CLI::Plugins::Git.new with args;" do

      shared_examples "For example, should call GemPlant::CLI::Plugins::Git.new with:" do |sample_params|
        context "For example," do
          let(:params) { sample_params }
          it "call with #{sample_params ? sample_params : 'nil'}" do
            GemPlant::CLI::Plugins::Git.should_receive(:new).with(sample_params)
            subject 
          end
        end
      end

      include_examples "For example, should call GemPlant::CLI::Plugins::Git.new with:", "/path/to/git/repo"
      include_examples "For example, should call GemPlant::CLI::Plugins::Git.new with:", nil

    end
  end

end
