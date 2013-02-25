# encoding: utf-8


require 'spec_helper'


describe GemPlant::CLI::Base do

  let(:klass) { GemPlant::CLI::Base }

  context "definition" do
    subject { klass }
    it { should be_kind_of Module }
    it { should be_kind_of Class }
    it { should respond_to :start }
    it { should respond_to :register }
  end

  it { should be_instance_of GemPlant::CLI::Base }
  it { should be_a Thor }

end
