#encoding: utf-8


module GemPlant

  # CLI用モジュール群
  #
  # @author tk_hamaguchi@xml-lab.jp
  # @version 0.0.1pre
  #
  module CLI

    module_function

    # CLIからの操作を実行する
    #
    # @param [Array] given_args (ARGV) コマンドを実行するための引数
    # @param [Hash] config ({}) 実行設定
    # @see http://rdoc.info/github/wycats/thor/master/Thor/Base/ClassMethods#start-instance_method Thor.startを参照
    #
    def start(given_args=ARGV, config={})
      Base.start(given_args,config)
    end

    # Registers another Thor subclass as a command.
    #
    # @param [Class] klass 登録するThorを含んだクラス
    # @param [String] subcommand_name サブコマンドの実行名
    # @param [String] usage サブコマンドの使い方
    # @param [String] description サブコマンドの説明
    # @param [Hash] options ({}) 実行時オプション
    # @see http://rdoc.info/github/wycats/thor/master/Thor#register-class_method Thor.registerを参照
    #
    def register(klass, subcommand_name, usage, description, options = {})
      Base.register(klass, subcommand_name, usage, description, options)
    end

  end

end
