# encoding: utf-8


module GemPlant
  module CLI
    module Plugins
      class Git
        attr_accessor :repo


        def initialize(git_inited_directory=nil)
          open(git_inited_directory) if git_inited_directory
        end
        
        def open(git_inited_directory)
          @repo = Grit::Repo.new(git_inited_directory)
        end

        def repo_dir
          @repo_dir ||= File.dirname(@repo.path)
        end


        def add(file)
          return false unless File::ftype(target_file(file)) == "file"
          Dir.chdir(@repo.working_dir) {
            p "===> #{ @repo.tree / file }"
            p "----> #{ (@repo.tree / file).name if (@repo.tree / file) }"
            unless blob = @repo.tree / file
              blob = Grit::Blob.create(@repo, {:name => file, :data => File.read(File.join(repo_dir,file))})
            end
            @repo.add(blob.name)
          }
          true
        end

        def mv(src,dest)
          Dir.chdir(@repo.working_dir) {
            #FileUtils.mv(File.join(gem_name,src), File.join(gem_name,dest))
            FileUtils.mv(src,dest)
            add dest
            rm src
          }
          true
        end

        def rm(file)
          @repo.remove(repos_file_name(file))
        end

        def target_file(file)
          File.join(repo_dir, file)
        end

        def repos_file_name(file)
          File.expand_path(file) #.gsub(/^#{repo_dir}\//,'')
        end

        def commit(message)
          @repo.commit_index(message)
          p @repo.tree.contents.collect{ |c| c.name }

        end

      end
    end
  end
end 

