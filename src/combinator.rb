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
            digit.many1.ret{|v| v.join }.expected('a number')
        end
    end

    module Unary
        # quantifer
        # module_function
        def maybe
            Maybe.new(self)
        end
        def many
            Many.new(self)
        end
        def many1
            Binder.new(self, Many.new(self)).ret{|v|
                [v.values[0]]+v.values[1]
            }
        end
    end

    module Binary
        def or(other)
            Brancher.new(self, other)
        end
        alias / or
    end

    class Parser
        include Unary
        include Binary
    end 

end

class Symbol
    def <=(other)
        unless Parser === other
            return super(other) 
        end
        other.clone.name(self)
    end
end
