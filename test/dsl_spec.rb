$: << '../src/'
require 'spec'
require 'parser.rb'
require 'combinator.rb'
require 'dsl.rb'

include Freac

describe DSL do
  it 'syn should add a method' do
    @p = freac do
      syn :test do |f|
        f.append(number)
        f.append(char('c'))
      end
    end
    r = @p.test.parse('123c')
    r.should be_ok
  end

  it 'syn could combinate it' do
    @p = freac do 
      syn :test do |f|
        f.number
        f.char('a')
      end
    end
    r = @p.test.parse('123a')
    r.should be_ok

    r = @p.test.parse('123b')
    r.should be_orz
  end
end



