require_relative './file'
require_relative './folder'
require 'pathname'

module Shift

  class ShiftFileNotFound < StandardError
  end
  
  class ShiftFileService

    def initialize(delegate = nil)
      @delegate = delegate
    end

    def read(folder = Shift::ShiftFolder.new)
      raise ShiftFileNotFound, "Shift file not found in #{folder.path}." if folder.shiftfile_path.nil?
      sf = Shift::ShiftFile.new(folder, self)
      return {
        :lanes => {},
        :rules => {},
        :before_all_block => nil,
        :before_each_block => nil,
        :after_all_block => nil,
        :after_each_block => nil
      } unless sf.content
      
      Dir.chdir(folder.path || Dir.pwd) do # context: fastlane subfolder
        # create nice path that we want to print in case of some problem
        relative_path = sf.path.nil? ? '(eval)' : Pathname.new(sf.path).relative_path_from(Pathname.new(Dir.pwd)).to_s
        
        # We have to use #get_binding method, because some test files defines method called `path` (for example SwitcherFastfile)
        # and local variable has higher priority, so it causes to remove content of original Fastfile for example. With #get_binding
        # is this always clear and safe to declare any local variables we want, because the eval function uses the instance scope
        # instead of local.

        # rubocop:disable Security/Eval
        eval(sf.content, sf.parsing_binding, relative_path) # using eval is ok for this case
        # rubocop:enable Security/Eval
      end

      return {
        :lanes => sf.lanes,
        :rules => sf.rules,
        :before_all_block => sf.before_all_block,
        :before_each_block => sf.before_each_block,
        :after_all_block => sf.after_all_block,
        :after_each_block => sf.after_each_block
      }
    end

    extend Forwardable

    def_delegators :@delegate, :method_missing

  end
end