module Freac
    module Combinator
        def any_char
            return Atom.new{|v| true }.expected('.')
        end
        def char(c)
            return Atom.new{|v| v==c }.expected(c)
        end
        def string(str)
            arr=[]
            str.each_char{|c|
                arr << char(c)
            }
            return Binder.new(*arr).expected(str).after{|v| str }
        end
        def one_of(str)
            Atom.new{|v| str.include? v }.expected("[#{str}]")
        end
        def none_of(str)
            Atom.new{|v| str.include? v}.expected("[^#{str}]")
        end
        def digit
            one_of("012345678").expected('a digit')
        end
        def number
            digit.many1.after{|v| v.values.join }
        end
    end

    module Unary
        # quantifer
        def maybe
            Maybe.new(self)
        end
        def many
            Many.new(self)
        end
        def many1
            Binder.new(self, Many.new(self))
        end
    end

    module Binary
        def /(other)
            Brancher.new(self, other)
        end
    end

    class Parser
        include Unary
        include Binary
    end
end
