require 'parse_result.rb'

module Freac

  class Parser
    def initialize(&blc)
      @expected = nil
      @after_blcs = []
    end
    def parse(input)
      r=self.do_parse(input)

      return r if r.orz?
      return r if not @after_blcs
      v=@after_blcs.inject(r.val){|acc, f|
        f.call(acc)
      }
      return ok(r.input, v)
    end
    def ret(&blc)
      @after_blcs << blc 
      return self
    end
    def expected(str=nil)
      if str
        @expected = str
        return self
      end
      return @expected
    end
    def name(sym=nil)
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
        result = p.parse(input)
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
    def append(p)
      @parsers << p
    end
    def do_parse(input)
      rest = input 
      rval = {}
      i=-1
      raise 'Null Parser' if @parsers == []
      for p in @parsers
        result = p.parse(rest)
        rest = result.input
        if result.ok?
          rval[i+=1] = result.val
          rval[p.name] = result.val if p.name
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
      result = @parser.parse(input)
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
        result=@parser.parse(rest)
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
