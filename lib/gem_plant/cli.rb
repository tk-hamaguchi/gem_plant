#encoding: utf-8


require 'thor'


module GemPlant

  class CLI < ::Thor
    include Thor::Actions

    # @private
    def self.source_root
      File.dirname(__FILE__)
    end


    desc "generate GEM_NAME",
      'Generate rubygems templates. (short-cut alias: "g")'
    method_option :cucumber,
      :aliases => "-c",
      :type    => :boolean,
      :desc    => "Generate with cucumber templates.",
      :alias   => :g,
      :default => true
    def generate(name)
      puts name
    end

  end

end
