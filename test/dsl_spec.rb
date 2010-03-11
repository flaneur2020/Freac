$: << '../src/'
require 'spec'
require 'parser.rb'
require 'combinator.rb'
require 'dsl.rb'

include Freac

describe ParserDSL do
    it "could combinate parsers" do
        p = syn {
            char 'a'
            char 'b'
        }.after{|v|
            v.values.join
        }
        p.parsers.size.should == 2
        p.parse('ac').should be_orz
        r=p.parse('ab')
        r.should be_ok
        r.val.should == 'ab'
    end

    it "could give parser a name" do
        p = syn {
            char 'a'
            :b <= (char 'b')
        }.after{|v|
            v[:b]
        }
        p.parsers.size.should == 2
        r=p.parse('ab')
        r.val.should == 'b'
    end

    it "binary combinators " do
        p = syn {
            :c <= char('a') / char('b')
        }.after{|v|
            v[:c]
        }
        r=p.parse('a')
        r.should be_ok
        r.val.should=='a'
        p.parse('b').val.should =='b'
        p.parse('c').should be_orz
    end
end
