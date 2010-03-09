module Freac

    class Parser
        attr_accessor :name
        attr_accessor :parent

        def initialize
            @name=nil
            @expected||=''
            @parent=nil
        end

        def check(input)
        end

        def or (other)
            super(other) unless Parser === other 

            r = Brancher.new(self, other)
            if self.parent
                ps = self.parent.ps
                ps.pop
                ps.pop
                r.parent = self.parent
                ps << r
            end
            return r
        end
        alias / or 

        def many
            syn {

            }
        end

        def expected(val=nil)
            if val
                @expected = val
                return self
            end
            return @expected
        end

        def error(input, inferer)
            inferer||='' 
            return [nil, input, expected, inferer]
        end
    end

    class Atom < Parser
        def initialize(&blc)
            @p=blc
            super()
        end
        def check(input)
            return error(input, "") if input==""
            x, xs = [input[0..0], input[1..-1]]
            if @p.call(x)
                return [x, xs]
            else
                return error(input, input)
            end
        end
    end

    class Binder < Parser
        attr_accessor :ps
        def initialize(*ps, &blc)
            super()
            @ps = ps
            ret = instance_eval(&blc) if blc
            @ret_blc = ret if String === ret
        end
        def check(input)
            rest = input 
            scope = {}
            for p in @ps
                r, rest = result = p.check(rest)
                if not r
                    result[1]=input
                    return result
                end
                scope[p.name] = r if p.name
            end
            if @ret_blc
                ret = eval @ret_blc, closure(scope)
                result[0] = ret
            end

            return result
        end

        def char(ec)
            make_parser{ 
                Atom.new{|ic| ec==ic }
            }.expected(ec)
        end

        def word(w)
            make_parser {
                syn{
                w.each_char{|c|
                char c
            }
            %{ '#{w}' }
            }
            }.expected(w)
        end

        #######
        private
        #######

        def make_parser()
            p = yield 
            @ps << p
            p.parent = self
            return p
        end
    end

    def syn(&blc)
        Binder.new(&blc)
    end

    class Closure
        def initialize(scope)
            for k, v in scope
                eval %{
                @#{k}='#{v}'
                }
            end
        end
        def get_binding
            binding
        end
    end
    def closure(scope)
        Closure.new(scope).get_binding
    end



    class Returner < Parser
        attr_reader :blc
        def initialize(&blc)
            @blc=blc
        end
        def check(input)
            return ['', input]
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
            return error(input, rest)
        end

        def |(other)
            r = Brancher.new(self, other)
            return r
        end
    end

    def char(c)
        Atom.new{|ec| 
            ec==c
        }.expected(c)
    end

    def word(w)
        syn{
            w.each_char{|c|
            char c
        }
        %{ '#{w}' }
        }.expected(w)
    end

end

class Symbol
    def <=(other)
        return super(other) if not Parser===other
        other.name=self
        return other
    end
end
