# encoding: utf-8


require 'spec_helper'


describe GemPlant::CLI do

  context "definition" do
    subject { described_class }
    it { should be_kind_of Module }
    it { should_not be_kind_of Class }
    it { should respond_to :start }
    it { should respond_to :register }
  end

  context ".start" do

    let(:mock_args) { ['-a', '-b', '--ccc', 'ddd' 'eee'] }
    let(:mock_config) { { :aaa => "AAA", :bbb => "BBB" } }
    let(:mock_response) { "response" }

    subject { described_class.start(mock_args, mock_config) }

    before { GemPlant::CLI::Base.stub!(:start).and_return( mock_response ) }

    it "should return GemPlant::CLI::Base.start response" do
      should == mock_response
    end

    it "should call GemPlant::CLI::Base.start with args" do
      GemPlant::CLI::Base.should_receive(:start).with(mock_args, mock_config) 
      subject
    end

  end

  context ".register" do

    let(:mock_klass) { Object }
    let(:mock_subcommand_name) { 'subcommand' }
    let(:mock_usage) { 'usage' }
    let(:mock_description) { 'description' }
    let(:mock_options) { { :xxx => "UUU" } }

    let(:mock_args) { ['-a', '-b', '--ccc', 'ddd' 'eee'] }
    let(:mock_config) { { :aaa => "AAA", :bbb => "BBB" } }
    let(:mock_response) { "response" }

    subject { described_class.register(mock_klass, mock_subcommand_name, mock_usage, mock_description, mock_options) }

    before { GemPlant::CLI::Base.stub!(:register).and_return( mock_response ) }

    it "should return GemPlant::CLI::Base.register response" do
      should == mock_response
    end

    it "should call GemPlant::CLI::Base.register with args" do
      GemPlant::CLI::Base.should_receive(:register).with(mock_klass, mock_subcommand_name, mock_usage, mock_description, mock_options) 
      subject
    end

  end

end
