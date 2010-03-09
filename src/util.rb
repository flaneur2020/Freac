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

class Symbol
    def <=(other)
        return super(other) if not Parser===other
        other.name=self
        return other
    end
end
