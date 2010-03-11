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

    it "binary combinators like / can bind two combinators" do
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

    it "unary combinators can transform a parser" do
        p = syn {
            char('a').many
            :v <= char('b').many
        }.after{|v|
            v[:v].join
        }
        p.parsers.size.should == 2
        r=p.parse('aaaaaaaaaaaaabbb')
        r.should be_ok
        r.val.should == 'bbb'
    end
    
    it "binary combinators and unarys can works together well" do
        p = syn {
            char('a').many / (char('b').many)
        }
        p.parse('aaaaaaaaa').should be_ok
        p.parse('bbbbbbbbbbbb').should be_ok
    end
    
end
