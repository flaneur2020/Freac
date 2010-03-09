require 'test/unit'

require 'freac.rb'

include Freac

class FCTest < Test::Unit::TestCase

    def test_nop
        assert(1==1)
    end
    
    def test_char
        p1 = char 'a'
        ase ['a',''], p1.check('a')
        ase [nil,'b', 'a', 'b'], p1.check('b')
    end

    def test_binder
        p1 = char 'a'
        p2 = char 'b'
        p3 = Binder.new(p1, p2)
        ase ['b', ''], p3.check('ab')[0..1]
        asne ['b', ''], p3.check('aa')[0..1]
    end


    def test_word
        p1 = syn {
            char 'a'
            char 'b'
            char 'c'
            %{ 'abc' }
        }
        p2 = word 'abc'
        
        ase [nil, 'ab', 'abc', ''], p2.check("ab")
    end


    def test_brancher
        p1 = char 'a'
        p2 = char 'b'
        p3 = Brancher.new(p1, p2)
        ase ['a', ''], p3.check('a')
        ase [nil, 'x'], p3.check('x')[0..1]

        p3 = char('a') / char('b')
        ase ['a', 'bblah'], p3.check('abblah')
        ase ['b', ''], p3.check('b')
        ase [nil, 'c'], p3.check('c')[0..1]
    end

    def test_bra2
        p1 = word 'abc'
        p2 = word 'cba'
        p3 = word('abc') / word('cba')
        ase 'abc', p3.check('abcd')[0]
        ase 'cba', p3.check('cbad')[0]
        ase nil, p3.check('cad')[0]
    end

    def test_bra3
        p2 = word('abc')
        p3 = syn {
            :a <= word('abc') / word('cba') / word('orz')
            :b <= word('xxx')
            %{ @a+@b }
        }
        ase 'abc', p2.check('abc')[0]
        ase 'cbaxxx', p3.check('cbaxxx')[0]
        ase 'cbaxxx', p3.check('cbaxyx')
        ase nil, p3.check('abcd')[0]
    end

    def test_name
        p1 = :x <= char('a')
        ase :x, p1.name
    end

    def test_dsl

        p1 = syn {
            :a <= char('a') 
            :b <= char('b')
            :c <= char('c')
            %{ @a + @b }
        }
        ase ['ab', ''], p1.check('abc')
    end

    def dsl2
        puts "test_dsl2"
        p1 = char 'a'
        p2 = Binder.new {
            p1
        }
        p3 = Binder.new {
            p2
            char 'b'
        }
        ase 'b', p3.check('ab')[0]
    end

    def ase(e, v)
        assert_equal(e, v)
    end
    def asne(e, v)
        assert_not_equal(e, v)
    end
end

