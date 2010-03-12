$: << '../src/'
require 'spec'
require 'parser.rb'
require 'combinator.rb'

include Freac
include Freac::Combinator

describe Combinator do
    
    it "string should parse a string ok" do
        p = string 'abc'
        p.parse('abc').should be_ok
        r=p.parse('abcd')
        r.should be_ok
        r.input.should == 'd'
        r.val.should == 'abc'

        r=p.parse('acc')
        r.should be_orz
        r.expected.should == 'b'
        r.inferer.should == 'c'
    end
    it "maybe can parse all ok" do
        p = string('abc').maybe

        p.parse('abc').should be_ok
        
        r=p.parse('ab')
        r.should be_ok
        r.input.should == 'ab'
    end
    it "one_of matches only some" do
        p = one_of('abc')
        p.parse('a').should be_ok
        p.parse('b').should be_ok
        p.parse('z').should be_orz
    end

    it "digit only parses digit ok" do
        p = digit
        p.parse('1').should be_ok
        p.parse('a').should be_orz
    end

    it "number only parse number ok" do
        p = number
        p.parse('1').should be_ok
        r=p.parse('1234')

        r.should be_ok
        r.val.should == '1234'
    end
end

describe Unary do
    it "could transform a parser into another" do
        p = digit.many1
        p.parse('123').should be_ok
        p.parse('d23').should be_orz
    end

    it "or cound make a brancher" do
        p = digit.or char('c')
        p.parse('1').should be_ok
        p.parse('c').should be_ok
        p.parse('.').should be_orz
    end
end


