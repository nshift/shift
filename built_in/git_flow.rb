module Shift
  module BuiltIn
    class GitFlow

      class ValidationError < ShiftError
      end

      def self.execute(arguments)
        raise UnknownAction.new({message: "You should provide a valid action."}) unless !arguments[0].nil?
        case arguments[0]
        when :validate
          GitFlow.validate
        else
          raise UnknownAction.new({message: "Unknown action: #{arguments[0]}."})
        end
      end

      def self.validate
        branches = BuiltIn::Sh.execute(["git branch -a"])
        raise ValidationError.new({message: "master branch is missing."}) if branches.match(/remotes\/origin\/master/).nil?
        raise ValidationError.new({message: "develop branch is missing."}) if branches.match(/remotes\/origin\/develop/).nil?
        non_git_flow_branches = branches.scan(/remotes\/origin\/(?!(feature|develop|master|release|hotfix))(.+)/)
        raise ValidationError.new({message: "The following branches are not compatible with Git flow: #{non_git_flow_branches.join(', ')}"}) if non_git_flow_branches.count > 0
      end
    end
  end
end