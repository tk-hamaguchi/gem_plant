# encoding: utf-8


require 'bundler/cli'
require 'grit'
require 'gem_plant/cli/helpers/git_helper'


# CLIのGemテンプレートジェネレータ
#
# @author tk_hamaguchi@xml-lab.jp
# @version 0.0.1pre
#
class GemPlant::CLI::Generator < Thor::Group
  include Thor::Actions, GemPlant::CLI::GitHelper

  source_root File.expand_path('../../../', File.dirname(__FILE__))

  desc 'Generate rubygems templates. (short-cut alias: "g")'
  class_options :alias => "-g"
  class_option "fruit", :aliases => "-f", :type => :string, :enum => %w(apple banana)


  argument :gem_name,
    :required => true,
    :type     => :string

  class_option :cucumber,
    :aliases => "-c",
    :type    => :boolean,
    :desc    => "Generate with cucumber templates.",
    :default => true

  class_option :rspec,
    :aliases => "-r",
    :type    => :boolean,
    :desc    => "Generate with rspec templates.",
    :default => true

  class_option :yard,
    :aliases => "-y",
    :type    => :boolean,
    :desc    => "Generate with yard templates.",
    :default => true


  # bundle gemを実行する
  # 
  # @see Bundler::CLI#gem
  #
  def bundle_gem
    Bundler::CLI.new.gem(gem_name)
  end


  # bundlerによるgem生成直後の状態を一度コミット
  def git_first_commit
    git.open(gem_name)
    Dir.glob(File.join(gem_name,'**/*')) { |file|
      git.add File.expand_path(file).gsub(/^#{git.repo_dir}\//,'')
    }
    git.commit("first commit with \"bundle gem #{gem_name}\".")
  end


  # .gitignoreを編集
  def modify_gitignore
    gitignore_file = File.join(gem_name, '.gitignore')
    gsub_file(gitignore_file, /^(Gemfile.lock|doc\/)$/, '#\1')
    append_file(gitignore_file) do
      <<-EOS

doc/yardoc
*.swp
      EOS
    end
    git.add '.gitignore'
  end


  # LICENSE.txtをリネーム
  def rename_license
    git.mv 'LICENSE.txt', 'MIT-LICENSE.txt'
  end


  # Gemfileの編集
  def update_gemfile
    gsub_file(File.join(gem_name, 'Gemfile'), /^#\s*.*\n/, '')
    append_file(File.join(gem_name, 'Gemfile')) do
      append_str = ['']
      append_str << <<-EOS
# Add from GemPlant
gem "rake"
      EOS
      if options['yard']
        append_str << <<-EOS
gem "yard", require: false
gem "redcarpet", require: false
        EOS
      end
      append_str << "group :test do" if (options['cucumber'] || options['rspec'])
      if options['cucumber']
        append_str << <<-EOS
  gem 'cucumber'
  gem 'aruba'
        EOS
      end
      if options['rspec']
        append_str << <<-EOS
  gem 'rspec', '~>2.13.0'
  gem 'simplecov'
  gem 'simplecov-rcov'
        EOS
      end
      append_str << "end" if (options['cucumber'] || options['rspec'])
      append_str.join("\n")
    end
    git.add('Gemfile')
  end


  # .bundleを生成
  def copy_bundle_config
    directory(File.join('templates','bundler','.bundle'), File.join(gem_name,'.bundle'))
  end


  # cucumber関連ファイルの追加
  def copy_features
    if options['cucumber']
      directory(File.join('templates','cucumber','features'), File.join(gem_name,'features'))
      template(File.join('templates','cucumber','build.feature.tt'), File.join(gem_name, 'features', 'build.feature'))
      directory(File.join('templates','cucumber','tasks'), File.join(gem_name,'lib','tasks'))
    end
    git.add "features/step_definitions/gem_steps.rb"
    git.add "features/support/env.rb"
    git.add "features/build.feature"
    git.add "lib/tasks/cucumber.rake"
  end


  # rspec関連ファイルの追加
  def copy_specs
    if options['rspec']
      directory(File.join('templates','rspec','tasks'), File.join(gem_name,'lib','tasks'))
      copy_file(File.join('templates','rspec','.rspec'), File.join(gem_name,'.rspec'))
    end
    git.add "lib/tasks/rspec.rake"
    git.add ".rspec"
  end


  # yard関連ファイルの追加
  def copy_yardoc
    if options['yard']
      directory(File.join('templates','yard','tasks'), File.join(gem_name,'lib','tasks'))
    end
    git.add "lib/tasks/yard.rake"
  end


  # Rakefileへタスク追加
  def update_rakefile
    append_file(File.join(gem_name, 'Rakefile')) do
      append_str = ['']
      append_str << "Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each { |f| load f }" if File.exist?(File.join(gem_name,'lib','tasks'))
      default_tasks = []
      default_tasks << :spec if options['rspec']
      default_tasks << :features if options['cucumber']
      default_tasks << :yard if options['yard']
      append_str << "task :default => [ #{default_tasks.map{ |entry| ":#{entry}" }.join(', ')} ]" unless default_tasks.empty?
      append_str.join("\n")
    end
    git.add('Rakefile')
  end


  # 基底モジュールにドキュメント追加
  def modify_base_module
    base_module_file = File.join(gem_name, 'lib', "#{gem_name}.rb")
    gsub_file(base_module_file, /\n\s*#.+\n/, "\n")
    gem_class_name = File.read(base_module_file).match(/^module (\w+)$/)[1]
    insert_into_file base_module_file, before: "module" do
      <<-EOS
# #{gem_class_name} 基底モジュール
#
# @author #{git.repo.config["user.email"]}
# @since 1.0.0
#
      EOS
    end
    git.add File.join('lib', "#{gem_name}.rb")
  end


  # 基底モジュールのバージョンを変更
  def modify_base_module_version
    base_module_version_file = File.join(gem_name, 'lib', gem_name, 'version.rb')

    gsub_file(base_module_version_file, /\n\s*VERSION.+\n/, "\n")
    insert_into_file base_module_version_file, before: "end" do
      <<-EOS

  # バージョン情報
  #
  # @author #{git.repo.config["user.email"]}
  # @since 1.0.0
  #
  module VERSION

    # @return [Fixnum] メジャーバージョン番号
    MAJOR = 0

    # @return [Fixnum] マイナーバージョン番号
    MINOR = 0

    # @return [Fixnum] タイニーバージョン番号
    TINY  = 1

    # @return [String] サフィックス
    PRE   = "pre"

    # @return [String] バージョン情報
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")

  end

      EOS
    end
    git.add File.join('lib', gem_name, 'version.rb')
  end





  # これまでの変更をコミット
  def git_commit
    git.commit("Commit with updeted files.")
  end

end


GemPlant::CLI.register(GemPlant::CLI::Generator, 'generate', 'generate GEM_NAME', GemPlant::CLI::Generator.desc)
