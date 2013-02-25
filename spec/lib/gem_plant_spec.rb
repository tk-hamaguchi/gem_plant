# encoding: utf-8

require 'spec_helper'

describe GemPlant do

  context "definition" do
    subject { described_class }
    it { should be_a_kind_of Module }
    it { should_not be_a_kind_of Class }
  end

end
