require 'forwardable'

module Shift
  
  class FileDoesNotExist < StandardError
  end

  class ShiftFile

    attr_accessor :lanes, :rules, :path, :content, :delegate

    attr_accessor :before_all_block, :before_each_block, :after_all_block, :after_each_block

    # @return The runner which can be executed to trigger the given actions
    def initialize(folder = nil, delegate = nil)
      return unless (folder.shiftfile_path || '').length > 0
      puts "Could not find Fastfile at path '#{path}'" unless File.exist?(folder.shiftfile_path)
      @lanes ||= {}
      @rules ||= {}
      @path = File.expand_path(folder.shiftfile_path)
      @content = File.read(folder.shiftfile_path, encoding: "utf-8")
      @delegate = delegate
      @before_all_block = nil
      @before_each_block = nil
      @after_all_block = nil
      @after_each_block = nil

      # From https://github.com/orta/danger/blob/master/lib/danger/Dangerfile.rb
      if content.tr!('“”‘’‛', %(""'''))
        # UI.error("Your #{File.basename(path)} has had smart quotes sanitised. " \
        #         'To avoid issues in the future, you should not use ' \
        #         'TextEdit for editing it. If you are not using TextEdit, ' \
        #         'you should turn off smart quotes in your editor of choice.')
      end

      content.scan(/^\s*require (.*)/).each do |current|
        # gem_name = current.last
        # next if gem_name.include?(".") # these are local gems
        # UI.important("You have require'd a gem, if this is a third party gem, please use `fastlane_require #{gem_name}` to ensure the gem is installed locally.")
      end
    end

    def parsing_binding
      binding
    end

    #####################################################
    # @!group DSL
    #####################################################

    # User defines a new lane
    def lane(lane_name, &block)
      puts "You have to pass a block using 'do' for lane '#{lane_name}'. Make sure you read the docs on GitHub." unless block

      # TODO: Raise an error if there is duplicate lane.
      @lanes[lane_name] = block
    end

    def def_rule(rule_name, &block)
      @rules[rule_name] = block
    end

    def before_all(&block)
      @before_all_block = block
    end

    def before_each(&block)
      @before_each_block = block
    end

    def after_all(&block)
      @after_all_block = block
    end

    def after_each(&block)
      @after_each_block = block
    end

    extend Forwardable

    def_delegators :@delegate, :method_missing
  end
end