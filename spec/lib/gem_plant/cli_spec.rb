# encoding: utf-8


require 'spec_helper'


describe GemPlant::CLI do

  let(:klass) { GemPlant::CLI }

  context "definition" do
    subject { klass }
    it { should be_kind_of Class }
  end

  it { should be_instance_of GemPlant::CLI }
  it { should be_kind_of Thor }

end
