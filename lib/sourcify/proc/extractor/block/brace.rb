module Sourcify
  module Proc
    module Extractor
      module Block
        class Brace < Base

          def invalid?
            !!@invalid
          end

          def dubious?
            !!@dubious
          end

          def done?
            return true if invalid?

            @done ||=
              if @frags[-1] == '}' && correct?(s = body)
                !!(@body = s)
              end
          end

          def body
            @body ||
              begin
                block = %( #{@frags*''})
                expr = sexp(block)

                if expr && expr[1] && (e = expr[1][0])[0] == :hash
                  if e[1].nil?
                    @dubious = true
                  else
                    @invalid = true
                    return
                  end
                end

                encode(@type + block)
              end
          end

        end
      end
    end
  end
end