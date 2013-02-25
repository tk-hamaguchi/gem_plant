# encoding: utf-8

require 'gem_plant/cli/plugins/git'

module GemPlant
  module CLI
    module Helpers
      module GitHelper

        def git(repo=nil)
          @git ||= GemPlant::CLI::Plugins::Git.new(repo)
        end
      end
    end
  end
end 
