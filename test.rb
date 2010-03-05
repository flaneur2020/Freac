require 'test/unit'

require 'freac.rb'


class FCTest < Test::Unit::TestCase

    def test_nop
        assert(1==1)
    end
    
    def test_char
        p1 = char 'a'
        ase ['a',''], p1.check('a')
    end

    def test_binder
        p1 = char 'a'
        p2 = char 'b'
        p3 = Binder.new(p1, p2)
        ase ['b', ''], p3.check('ab')
        asne ['b', ''], p3.check('aa')
    end

    def test_brancher
        p1 = char 'a'
        p2 = char 'b'
        p3 = Brancher.new(p1, p2)
        ase ['a', ''], p3.check('a')
        ase [nil, 'x'], p3.check('x')
    end

    def test_name
        p1 = :x <= char('a')
        ase :x, p1.name
    end

    def test_dsl
        puts "test_dsl"
        p1 = FreacDSL.new {
            :a <= char('a')
            :b <= char('b')
        }
        puts "!!!!!!!!!!"
        ase ['b', ''], p1.check('ab')
        ase 2, p1.scope.size
    end

    def ase(e, v)
        assert_equal(e, v)
    end
    def asne(e, v)
        assert_not_equal(e, v)
    end
end

