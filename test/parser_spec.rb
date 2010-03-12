$: << '../src/'
require 'spec'
require 'parser.rb'

include Freac

describe Atom do
    p = Atom.new{|v| v=='c' }.expected('c')

    it "should expect as it tells" do
        p.expected.should == 'c'
    end

    it "should parse an 'c' ok " do
        r=p.parse('c')
        r.should be_ok
        r.input.should == ''
    end

    it "should parse other char orz" do
        p.parse('').should be_orz
        p.parse('x').should be_orz
        
        r=p.parse('v')
        r.expected.should == 'c'
        r.inferer.should == 'v'
    end
end

describe Binder do
    a1 = Atom.new{|v| v=='a' }.expected('a')
    a2 = Atom.new{|v| v=='b' }.expected('b')
    p = Binder.new(a1, a2)

    it "should sequence two parser ok" do
        p.parse('ab').should be_ok
        r=p.parse('abc')
        r.should be_ok
        r.input.should == 'c'
    end
        
    it "should parse other orz" do
        p.parse('ba').should be_orz

        r=p.parse('ac')
        r.should be_orz
        r.input.should == 'ac'
        r.expected.should == 'b'
        r.inferer.should == 'c'
    end

    it "should return an hash with int index" do
        p.parse('ab').val.class.should == Hash
    end

    it "should return an hash with name if children have got any name" do
        p = Binder.new(a1.name(:a1), a2.name(:a2)).ret{|v|
            v
        }

        r=p.parse('ab')
        r.should be_ok
        r.val[:a2].should == 'b'
        r.val[:a1].should == 'a'
    end
end

describe Brancher do
    a1 = Atom.new{|v| v=='a' }.expected('a')
    a2 = Atom.new{|v| v=='b' }.expected('b')
    p = Brancher.new(a1, a2)

    it 'should compose two parser into one brancher' do
        p.parse('a').should be_ok
        p.parse('b').should be_ok
    end

    it 'should parse other orz' do
        r=p.parse('c')
        r.should be_orz
        r.expected.should == ['a', 'b']
    end
end

describe Maybe do
    a1 = Atom.new{|v| v=='a' }.expected('a')
    p = Maybe.new(a1)

    it 'should parse ok all the time' do
        r=p.parse('a')
        r.should be_ok
        r.val.should == 'a'
        r.input.should == ''

        r=p.parse('b')
        r.should be_ok
        r.val.should == nil
        r.input.should == 'b'
    end
end

describe Many do
    a1 = Atom.new{|v| v=='a' }.expected('a')
    p = Many.new(a1)

    it 'should parse ok all the time too' do
        p.parse('a').should be_ok
        p.parse('aaa').should be_ok
        p.parse('aaaaaaaaaaa').should be_ok

        str='aaa'
        r=p.parse(str)
        r.should be_ok
        r.val.should == ['a', 'a', 'a'] 
        r.input.should == ''

        r=p.parse('aab')
        r.should be_ok
        r.val.should == ['a', 'a']
        r.input.should == 'b'

        r=p.parse('bb')
        r.should be_ok
        r.val.should == []
        r.input.should == 'bb'
    end
end
