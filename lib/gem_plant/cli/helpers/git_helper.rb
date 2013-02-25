# encoding: utf-8

require 'gem_plant/cli/plugins/git'

module GemPlant
  module CLI

    # Gitの機能を提供するためのヘルパーモジュール
    # 
    # @author tk_hamaguchi@xml-lab.jp
    # @version 0.0.1pre
    #
    module GitHelper

      # GemPlant::CLI::Plugins::Gitのインスタンスを生成して返す
      #
      # @param [String] repo Gitリポジトリのパス
      # @return [GemPlant::CLI::Plugins::Git] 生成されたGemPlant::CLI::Plugins::Gitのインスタンス
      #
      def git(repo=nil)
        @git ||= GemPlant::CLI::Plugins::Git.new(repo)
      end

    end

  end
end 
