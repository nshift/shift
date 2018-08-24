module Shift
  module BuiltIn
    class Guideline
      class GithubCommunity

        class ValidationError < ShiftErrors
        end

        def self.validate(arguments)
          errors = []
          errors.push({ severity: :error, message: "README.md is missing." }) if ! File.exists?("README.md")
          GithubCommunity.validate_markdown("README.md", errors) if File.exists?("README.md")
          errors.push({ severity: :error, message: "CONTRIBUTING.md is missing." }) if ! File.exists?("CONTRIBUTING.md")
          GithubCommunity.validate_markdown("CONTRIBUTING.md", errors) if File.exists?("CONTRIBUTING.md")
          errors.push({ severity: :warning, message: "MANIFESTO.md is missing." }) if ! File.exists?("MANIFESTO.md")
          GithubCommunity.validate_markdown("MANIFESTO.md", errors) if File.exists?("MANIFESTO.md")
          errors.push({ severity: :warning, message: "LICENSE is missing." }) if ! File.exists?("LICENSE")
          errors.push({ severity: :warning, message: "CODE_OF_CONDUCT.md is missing." }) if ! File.exists?("CODE_OF_CONDUCT.md")
          GithubCommunity.validate_markdown("CODE_OF_CONDUCT.md", errors) if File.exists?("CODE_OF_CONDUCT.md")
          errors.push({ severity: :error, message: ".github is missing." }) if ! Dir.exist?(".github")
          errors.push({ severity: :error, message: "ISSUE_TEMPLATE is missing." }) if ((! Dir.exist?(".github/ISSUE_TEMPLATE") || Dir.empty?(".github/ISSUE_TEMPLATE")) &&
            (! Dir.exist?(".github/issue_template") || Dir.empty?(".github/issue_template")) &&
            (! File.exists?(".github/ISSUE_TEMPLATE.md")) &&
            (! File.exists?(".github/issue_template.md")))
          errors.push({ severity: :error, message: "PULL_REQUEST_TEMPLATE is missing." }) if ((! Dir.exist?(".github/PULL_REQUEST_TEMPLATE") || Dir.empty?(".github/PULL_REQUEST_TEMPLATE")) &&
            (! Dir.exist?(".github/pull_request_template") || Dir.empty?(".github/pull_request_template")) &&
            (! File.exists?(".github/PULL_REQUEST_TEMPLATE.md")) &&
            (! File.exists?(".github/pull_request_template.md")))
          raise ValidationError.new(errors) if errors.count > 0
        end

        private

        def self.validate_markdown(file_path, errors)
          begin
            BuiltIn::Markdown.validate(file_path)
          rescue MarkdownError => markdown_error
            errors.push({ severity: :error, message: markdown_error.message })
          end
        end
      end
    end
  end
end