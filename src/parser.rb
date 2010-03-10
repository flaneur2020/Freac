require 'parse_result.rb'

module Freac

    class Parser
        def initialize
            @expected = nil
            @after_blc = nil
        end
        def parse(input)
            r=self.do_parse(input)

            return r if r.orz?
            return r if not @after_blc
            v=@after_blc.call(r.val) 
            return ok(r.input, v)
        end
        def after(&blc)
            @after_blc = blc 
            return self
        end
        def expected(str=nil)
            if str
                @expected = str
                return self
            end
            return @expected
        end
        def name(sym)
            if sym
                @name = sym
                return self
            end
            return @name
        end
    end

    class Atom < Parser
        def initialize(&blc)
            @cond=blc
            super()
        end
        def do_parse(input)
            return orz(input, '', self.expected) if input==""

            x, rest = [input[0..0], input[1..-1]]
            if @cond.call(x)
                return ok(rest, x)
            else
                return orz(input, x, self.expected)
            end
        end
    end

    # <|>
    class Brancher < Parser
        def initialize(*parsers)
            super()
            @parsers = *parsers
            @expected = parsers.map{|p| p.expected }
        end
        def do_parse(input)
            for p in @parsers
                result = p.do_parse(input)
                return result if result.ok?
            end
            return orz(input, result.inferer, self.expected)
        end
    end

    # >>
    class Binder < Parser
        def initialize(*parsers)
            super()
            @parsers = parsers
        end
        def do_parse(input)
            rest = input 
            rval = {}
            i=0
            for p in @parsers
                result = p.do_parse(rest)
                rest = result.input
                if result.ok?
                    rval[i+=1] = result.val
                else
                    return orz(input, result.inferer, result.expected)
                end
            end
            return ok(result.input, rval)
        end
    end

    # ?
    class Maybe < Parser
        def initialize(p)
            @parser=p
        end
        def do_parse(input)
            result = @parser.do_parse(input)
            if result.ok?
                return result
            else
                return ok(input, nil)
            end
        end
    end
    # * 
    class Many < Parser
        def initialize(p)
            @parser=p
        end
        def do_parse(input)
            rest=input
            rval=[]
            while true
                result=@parser.do_parse(rest)
                if result.ok?
                    rval << result.val
                    rest = result.input
                else 
                    return ok(rest, rval)   
                end
            end
        end
    end
end
