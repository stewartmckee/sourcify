require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe "Method#to_source from def ... end block (w nested class)" do

  class AA; end

  should 'handle singleton' do
    def m1
      class << AA
        def aa
          @x1 = 1
        end
      end
    end
    method(:m1).should.be having_source(%(
      def m1
        class << AA
          def aa
            @x1 = 1
          end
        end
      end
    ))
  end

  should 'handle nested' do
    def m2
      class << AA
        class BB
          def bb
            @x1 = 1
          end
        end
      end
    end
    method(:m2).should.be having_source(%(
      def m2
        class << AA
          class BB
            def bb
              @x1 = 1
            end
          end
        end
      end
    ))
  end

end