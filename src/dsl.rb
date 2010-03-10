require 'combinator.rb'

module Freac

    class ParserDSL < Binder
        def initialize(&blc)
            super()
            instance_eval &blc if blc
        end

        attr :parsers
        Combinator.instance_methods.each{|m|
            define_method(m){|*args|
                p = Combinator::send(m, *args)
                @parsers << p
                p
            }
        }
    end
    def syn(&blc)
        ParserDSL.new(&blc)
    end
end

module EmptyModule 
end

class Symbol
    def <=(other)
        unless Parser === other
            return super(other) 
        end
        other.name(self)
    end
end
