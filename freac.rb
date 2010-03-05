class Parser
    attr_accessor :name
    def initialize
        @name=nil
    end
    def check(input)
    end
end

class Atom < Parser
    def initialize(p)
        @p=p
        super()
    end
    def check(input)
        return [nil, ''] if input==""
        x, xs = [input[0..0], input[1..-1]]
        if @p.call(x)
            return [x, xs]
        end
    end
end

class Binder < Parser
    def initialize(*ps)
        @ps = ps
        super()
    end
    def check(input)
        rest = input 
        scope = {}
        for p in @ps
            r, rest = result = p.check(rest)
            return [nil, input] if not r
            scope[p.name] = r if p.name
        end
        result << scope

        return result
    end
end

class Brancher < Parser
    def initialize(p1, p2)
        @p1, @p2 = [p1, p2]
        super()
    end
    def check(input)
        r1, rest = @p1.check(input)
        return [r1, rest] if r1
        r2, rest = @p2.check(input)
        return [r2, rest] if r2
        return [nil, input]
    end
end

def char(c)
    return Atom.new(lambda {|ec| 
        ec==c
    })
end

# 
# p2 = syn {
#   char 'a'
#   char 'b'
#   char 'c'
# }
class FreacDSL < Parser
    def initialize(&blc)
        @ps=[]
        super()
        
        instance_eval(&blc) if blc
    end
    def check(input)
        p = Binder.new(*@ps)
        r, input, scope = result = p.check(input)
        return result
    end
    def char(c)
        p = Atom.new(lambda {|ec|
            ec==c
        })
        @ps << p
        return p
    end
    def def_parser
        yield 
    end
end

    
class Symbol
    def <=(other)
        return super(other) if not Parser===other
        other.name=self
        return other
    end
end

