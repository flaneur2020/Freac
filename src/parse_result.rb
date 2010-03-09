module Freac

    class ParseResult
        def orz?
            true
        end
        def ok?
            not orz?
        end
    end

    class Ok < ParseResult
        attr_reader :val
        attr_reader :input

        def initialize(val, input)
            @val = val    
            @input = input
        end

        def orz?
            return false
        end
    end

    class Orz < ParseResult
        attr :input
        attr :expected
        attr :inferer

        def initialize(input, inferer, expected=nil)
            @input = input
            @inferer = inferer
            @expected = expected
        end

        def orz?
            return true
        end
    end

    def ok(*paras)
        Ok.new(*paras)
    end
    def orz(*paras)
        Orz.new(*paras)
    end
end

