require 'combinator.rb'

module Freac

    class ParserDSL < Binder
        def initialize(&blc)
            super()
            instance_eval &blc if blc
        end

        def char(c)
            p=Combinator::char(c)
            @parsers << p
            return p
        end 
    end
    def syn(&blc)
        ParserDSL.new(&blc)
    end

end

class Symbol
    def <=(other)
        unless Parser === other
            return super(other) 
        end
        other.name(self)
    end
end
