$: << '../src/'
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
