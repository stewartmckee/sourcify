module Sourcify
  module Common
    class Parser
      module RawScanner #:nodoc:all
        class DString < Struct.new(:tag, :encoding)

          # To suppress 'warning: Object#type is deprecated; use Object#class' when
          # evaluating string
          attr_reader :type

          def <<(content)
            (@contents ||= []) << content
          end

          def to_s
            @contents.join
          end

          def closed?
            evaluable? && parsable?
          end

          private

            CLOSING_TAGS = {'(' => ')', '[' => ']', '<' => '>', '{' => '}'}

            def evaluable?
              @contents.length >= 2 &&
                @contents[-1][-1].chr == end_tag
            end

            def parsable?
              !!RubyParser.new.parse(safe_contents)
            rescue SyntaxError, Racc::ParseError
              false
            end

            def safe_contents
              # NOTE: %x & ` strings are dangerous to eval cos they execute shell commands,
              # thus we convert them to normal strings 1st
              to_s.gsub(/(%x)(\W|\_)/, '%Q\2').gsub(/.{0,2}(`)/) do |s|
                s =~ /^(%Q|%W|%r|%x|.?%|.?\\)/ ? s : s.sub(/`$/,'%Q`')
              end.force_encoding(encoding)
            end

            def start_tag
              @start_tag ||= tag[-1].chr
            end

            def end_tag
              @end_tag ||= (CLOSING_TAGS[start_tag] || start_tag)
            end

        end
      end
    end
  end
end
