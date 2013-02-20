# encoding: utf-8

require 'spec_helper'

describe GemPlant do
  let(:klass) { GemPlant }

  context "definition" do
    subject { klass }
    it { should be_a_kind_of Module }
    it { should_not be_a_kind_of Class }
  end

end
