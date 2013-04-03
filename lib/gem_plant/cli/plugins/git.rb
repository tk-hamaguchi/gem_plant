# encoding: utf-8


module GemPlant
  module CLI
    module Plugins

      # Git用プラグイン
      #
      # @author tk_hamaguchi@xml-lab.jp
      # @version 0.0.1pre
      #
      class Git

        # @return [String] Gitリポジトリまでのパス
        attr_accessor :repo


        # コンストラクタ
        #
        # @param [String] git_inited_directory (nil) 初期化されたGitリポジトリ
        # @return [GemPlant::CLI::Plugins::Git] GemPlant::CLI::Plugins::Gitのインスタンス
        #
        def initialize(git_inited_directory=nil)
          open(git_inited_directory) if git_inited_directory
        end
        

        # 引数で与えられたパスを利用する
        #
        # @param [String] git_inited_directory 初期化されたGitリポジトリ
        # @return [GemPlant::CLI::Plugins::Git] GemPlant::CLI::Plugins::Gitのインスタンス
        #
        def open(git_inited_directory)
          @repo = Grit::Repo.new(git_inited_directory)
          self
        end


        # 引数で与えられたパスをリポジトリに追加する
        #
        # @param [String] file Gitリポジトリからの相対パス
        # @return [Boolean] 追加の成否
        #
        def add(file)
          return false unless File::ftype(target_file(file)) == "file"
          Dir.chdir(@repo.working_dir) {
            unless blob = @repo.tree / file
              blob = Grit::Blob.create(@repo, {:name => file, :data => File.read(target_file(file))})
            end
            @repo.add(file)
          }
          true
        end


        # 引数で与えられたパスのファイルをリポジトリ内で移動する
        #
        # @param [String] src 移動元ファイルのGitリポジトリからの相対パス
        # @param [String] dest 移動先のGitリポジトリからの相対パス
        # @return [Boolean] 移動の成否
        #
        def mv(src, dest)
          Dir.chdir(@repo.working_dir) {
            FileUtils.mv(src,dest)
            add dest
            rm src
          }
          true
        end


        # 引数で与えられたパスのファイルをリポジトリ内から削除する
        #
        # @param [String] file 削除するファイルのGitリポジトリからの相対パス
	# @return [Boolean] 削除の成否
        #
        def rm(file)
          Dir.chdir(@repo.working_dir) {
            @repo.remove(file)
          }
          true
        end


        # 引数で与えられたメッセージを利用してこれまでの変更をコミットします
        #
        # @param [String] message コミットログ
        # @return [Boolean] コミットの成否
        #
        def commit(message)
          @repo.commit_index(message)
          true
        end


        def repo_dir
          @repo.working_dir
        end

        private

          # @private
          def target_file(file)
            File.join(File.dirname(@repo.path), file)
          end

      end
    end
  end
end 

