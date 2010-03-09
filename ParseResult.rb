module Freac

    class ParseResult
        def fail?
            return true
        end
    end

    class Succ < ParseResult
        attr_reader :val
        attr_reader :input

        def initialize(val, input)
            @val = val    
            @input = input
        end

        def fail?
            return false
        end
    end

    class Fail < ParseResult
        attr :input
        attr :expected
        attr :inferer

        def initialize(input, expected, inferer)
            @input = input
            @expected = expected
            @inferer = inferer
        end

        def fail?
            return true
        end
    end

    def succ(*paras)
        Succ.new(*paras)
    end
    def fail(*paras)
        Fail.new(*paras)
    end
end

