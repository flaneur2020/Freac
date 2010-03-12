require 'combinator.rb'

module Freac

    def syn(*args)
        Binder.new(*args)
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
