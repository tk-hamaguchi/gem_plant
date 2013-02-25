#encoding: utf-8


require 'thor'


module GemPlant

  # CLIの基底クラス
  #
  # @author tk_hamaguchi@xml-lab.jp
  # @version 0.0.1pre
  #
  module CLI

    class Base < Thor
      
    end

    module_function

    def start(given_args=ARGV, config={})
      Base.start(given_args,config)
    end

    def register(klass, subcommand_name, usage, description, options = {})
      Base.register(klass, subcommand_name, usage, description, options)
    end

  end

end
