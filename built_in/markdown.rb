require 'kramdown'
require 'net/http'

module Shift

  class MarkdownUnknownCommand < StandardError
  end

  class MarkdownContainsNotFoundLink < StandardError
  end

  module BuiltIn
    class Markdown

      def self.name
        return File.basename(__FILE__, File.extname(__FILE__))
      end

      def self.execute(arguments)
        command = arguments[0]
        case command
        when :validate
          Markdown.validate(arguments[1])
        else
          raise MarkdownUnknownCommand, "#{arguments[0]} is a unknown command."
        end
      end

      def self.validate(file_path)
        content = Markdown.read_markdown_file(file_path)
        root = Kramdown::Document.new(content).root
        Markdown.validate_links(root)
      end

      def self.validate_links(root)
        links = Markdown.get_all_links(root)
        not_found_links = links.select { |link| 
          Markdown.url_exist?(link.attr["href"]) == false
        }
        if !not_found_links.empty?
          not_found_links_message = not_found_links.map {|link| "#{link.attr.inspect} #{link.options.inspect}"}.join(',')
          raise MarkdownContainsNotFoundLink, "Markdown contains not found link:\n#{not_found_links_message}" 
        end
      end

      def self.get_all_links(root)
        links = []
        root.children.each do |element|
          case Kramdown::Element.category(element)
          when :block
            links.concat(Markdown.get_all_links(element))
          when :span
            links << element if element.type == :a
          end
        end
        return links
      end

      def self.read_markdown_file(file_path)
        content = ''
        puts file_path
        file = File.open(file_path, "r")
        file.each_line do |line|
          content << line
        end
        file.close
        return content
      end

      def self.url_exist?(url_string)
        return false if !(url_string =~ URI::regexp)
        url = URI.parse(url_string)
        http = Net::HTTP.new(url.host, url.port)
        http.open_timeout = 3
        http.use_ssl = (url.scheme == 'https')
        path = url.path if !url.path.empty?
        res = http.request_head(path || '/')
        if res.kind_of?(Net::HTTPRedirection)
          url_exist?(res['location'])
        else
          ! %W(4 5).include?(res.code[0])
        end
      rescue SocketError
        return false
      rescue Timeout::Error
        return false
      rescue Errno::ENOENT
        return false
      end

    end
  end
end