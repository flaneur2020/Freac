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
        def maybe(p)
            Maybe.new(p)
        end
        def many(p)
            Many.new(p)
        end
        def many1(p)
            Binder.new(p, Many.new(p))
        end
        module_function :maybe, :many, :many1
    end

    module Binary
        def or(p, other)
            Brancher.new(p, other)
        end
        module_function :or
    end

    class Parser
        Unary.singleton_methods.each{|m|
            define_method(m){|*args|
                Unary.send(m, self)
            }
        }
        Binary.singleton_methods.each{|m|
            define_method(m){|*args|
                Binary.send(m, *([self]+args))
            }
        }
    end
end

