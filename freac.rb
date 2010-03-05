class Parser
    def check(input)
    end
end

class Sater < Parser
    def initialize(p)
        @p=p
    end
    def check(input)
        return [nil, ''] if input==""
        x, xs = [input[0..0], input[1..-1]]
        if @p.call(x)
            return [x, xs]
        end
    end
end

def char(c)
    return Sater.new(lambda {|ec| 
        ec==c
    })
end

class Binder < Parser
    def initialize(p1, p2)
        @p1, @p2 = [p1, p2]
    end
    def check(input)
        r1, rest = @p1.check(input)
        return [nil, input] if not r1
        r2, rest = @p2.check(rest)
        return [nil, input] if not r2
        return [r2, rest]
    end
end

class Brancher < Parser
    def initialize(p1, p2)
        @p1, @p2 = [p1, p2]
    end
    def check(input)
        r1, rest = @p1.check(input)
        return [r1, rest] if r1
        r2, rest = @p2.check(input)
        return [r2, rest] if r2
        return [nil, input]
    end
end
