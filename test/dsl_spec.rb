$: << '../src/'
require 'spec'
require 'parser.rb'
require 'combinator.rb'
require 'dsl.rb'

include Freac

describe DSL do
  it 'syn should add a method' do
    @p = freac do
      syn :test do |p|
        p.append(number)
        p.append(char('c'))
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

  it 'syn could call each other' do
    @p = freac do 
      syn :ab do |_|
        _.a
        _.b
        _.ret{
          'orz'
        }
      end
      syn :a do |_|
        _.char('a')
      end
      syn :b do |_|
        _.char('b')
      end
    end
    r = @p.ab.parse('ab')
    r.should be_ok
    r.val.should == 'orz'
  end

  it 'have a name' do
    @p = freac do
      syn :a_b do |_|
        _.char('a') >> :a
        _.char('b') >> :b
        _.ret do |v|
          v[:b] + v[:a]
        end
      end 
    end
    r = @p.a_b.parse('ab')
    r.should be_ok
    r.val.should == 'ba'
  end

  it 'should have an or' do
  end

end



