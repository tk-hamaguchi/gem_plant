# encoding: utf-8


require 'spec_helper'


describe GemPlant::CLI::Plugins::Git do

  it { should respond_to :repo= }
  it { should respond_to :repo }
  it { should respond_to :open }
  it { should respond_to :add }
  it { should respond_to :rm }
  it { should respond_to :mv }
  it { should respond_to :commit }
  it { should_not respond_to :target_file }

  context "#private_methods" do
    subject { described_class.new.private_methods }
    it { should include :target_file }
  end

  context "#open" do
    context "with no args" do
      it { expect { described_class.new.open }.to raise_error ArgumentError }
    end
    context "with args" do
      let(:mock_grit_repo) { mock(Grit::Repo) }
      let(:params) { "/path/to/repos" }
      subject { described_class.new.open params }
      before { Grit::Repo.stub!(:new).and_return(mock_grit_repo) }
      context "should call Grit::Repo.new with params;" do
        shared_examples "For example, should call Grit::Repo.new with:" do |sample_params|
          context "For example," do
            let(:params) { sample_params }
            it "call with #{sample_params}" do
              Grit::Repo.should_receive(:new).with(sample_params)
              subject
            end
          end
        end
        include_examples "For example, should call Grit::Repo.new with:", "/path/to/git/repo"
        include_examples "For example, should call Grit::Repo.new with:", "git-repo"
      end
      it "should set Grit::Repo instance to @repo" do
        subject.instance_variable_get(:@repo).should == mock_grit_repo
      end
      it { should be_instance_of described_class }
    end
  end

  context "#add" do
    context "with no args" do
      it { expect { described_class.new.add}.to raise_error ArgumentError }
    end
    context "with args" do
      let(:test_instance) { described_class.new }
      let(:grit_repo_working_dir) { 'tmp' }
      let(:mock_grit_repo) { mock(Grit::Repo, :working_dir => grit_repo_working_dir, :add => true, :tree => true) }
      let(:mock_grit_blob) { mock(Grit::Blob) }
      let(:mock_grit_tree) { mock(Grit::Tree, :/ => nil) }
      let(:params) { "path/to/add/file" }
      subject { test_instance.add params }
      before {
        test_instance.stub!(:target_file).and_return("path/to/repos/file")
        Dir.stub!(:chdir)
        File.stub!(:ftype).and_return("file")
        test_instance.instance_variable_set(:@repo, mock_grit_repo)
        Grit::Blob.stub!(:create).and_return(mock_grit_blob)
      }
      context "which is file path" do
        it { should be_true }
        it "should call Dir.chdir with Grit::Repo#working_dir result" do
          Dir.should_receive(:chdir) #.with(grit_repo_working_dir)
          subject
        end
        it "should call Dir.chdir with Grit::Repo#working_dir result" do
          mock_grit_repo.should_receive(:tree)
          subject
        end
        context "which is not included repository" do
          before { mock_grit_repo.stub!(:tree).and_return(mock_grit_tree) }
          it do
            mock_grit_tree.should_receive(:/).with(params)
            subject
          end
          it { should be_true }
          it "should call Grit::Blob#create with any args" do
            Grit::Blob.should_receive(:create).with(any_args())
            subject
          end
        end
      end
      
      context "which is not file path" do
        context "should be false;" do
          shared_examples "For example, File::ftype retrun to:" do |sample_result|
            context "For example," do
              before { File.stub!(:ftype).and_return(sample_result) }
              it "return #{sample_result}" do
                should_not be_true
              end
              it "Dir should not be call #chdir with any args" do
                Dir.should_not_receive(:chdir).with(any_args)
                subject
              end
            end
          end
          include_examples "For example, File::ftype retrun to:", "directory"
          include_examples "For example, File::ftype retrun to:", "link"
        end
      end

    end
  end

  context "#rm" do
    context "with no args" do
      it { expect { described_class.new.rm}.to raise_error ArgumentError }
    end
    context "with args" do
      let(:mock_grit_repo) { mock(Grit::Repo, :working_dir => 'tmp', :remove => true) }
      let(:test_instance) { described_class.new }
#      let(:mock_grit_blob) { mock(Grit::Blob) }
      let(:params) { "path/to/add/file" }
      subject { test_instance.rm params }
      before {
        Dir.stub!(:chdir)
#        subject.stub!(:target_file).and_return("path/to/repos/file")
#        File.stub!(:ftype).and_return("file")

        test_instance.instance_variable_set(:@repo, mock_grit_repo)
      }
      it { should be_true }
      

    end
  end
  
end
