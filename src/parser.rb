require 'parse_result.rb'

module Freac

    class Parser
        def initialize
            @expected = nil
        end

        def parse(input)
        end

        def expected(str=nil)
            if str
                @expected = str
                return self
            end
            return @expected
        end
    end

    class Atom < Parser
        def initialize(&blc)
            @cond=blc
            super()
        end
        def parse(input)
            return orz(input, '', self.expected) if input==""

            x, rest = [input[0..0], input[1..-1]]
            if @cond.call(x)
                return ok(x, rest)
            else
                return orz(input, x, self.expected)
            end
        end
    end

    class Brancher < Parser
        def initialize(*parsers)
            super()
            @parsers = *parsers
            @expected = parsers.map{|p| p.expected }
        end
        def parse(input)
            for p in @parsers
                result = p.parse(input)
                return result if result.ok?
            end
            return orz(input, result.inferer, self.expected)
        end
    end

    class Binder < Parser
        def initialize(*parsers)
            super()
            @parsers = parsers
        end
        def parse(input)
            rest = input 
            for p in @parsers
                result = p.parse(rest)
                rest = result.input
                if result.orz?
                    return orz(input, result.inferer, result.expected)
                end
            end
            return result
        end
    end
end
