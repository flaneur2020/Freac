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
                p.parent=self
                p
            }
        }
    end
    def syn(&blc)
        ParserDSL.new(&blc)
    end

    class Parser
        attr_accessor :parent
        Unary.singleton_methods.each{|m|
            define_method(m){|*args|
                p = Unary.send(m, self)
                if @parent
                    @parent.parsers.pop
                    @parent.parsers << p
                end
                p.parent=self
                p
            }
        }
        Binary.singleton_methods.each{|m|
            define_method(m){|*args|
                p=Binary.send(m, *([self]+args))
                if @parent
                    @parent.parsers.pop
                    @parent.parsers.pop
                    @parent.parsers << p
                end
                p.parent=self
                p
            }
        }
        alias / or
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
