class Facet
  attr_accessor :name, :options, :relevance
  
  def initialize(name)
    @options = {}
    @name = name
  end

  def relevance
    @relevance ||= calculate
  end

  private
    def calculate
      0.0 if @options.count < 1
      vals = @options.clone
      vals.delete(:total)
      
      non_null_weight_val = gauss(median(vals.values.map { |n| Float(n)/Float(@options[:total]) }))
      null_weight_val = null_weight(vals.values.inject(:+)/@options[:total])
      #binding.pry
      non_null_weight_val * null_weight_val
    end

    def median(array)
      array.sort[array.count/2]
    end

    # http://fooplot.com/0.4*(1/(0.15*sqrt(2*pi)))*e%5E(-0.5*((x-0.50)/(0.15))%5E2)
    def gauss(x = 0)
      #34/Math::sqrt(2*Math::PI*180)*Math::E**(-0.5*(percentage-50)**2/180)
      0.4*(1/(0.15*Math::sqrt(2*Math::PI)))*Math::E**(-0.5*((x-0.50)/(0.15))**2)
    end
    
    def sinus(x = 0)
      Math::sin(3.3*(x-0.025))
    end
    
    def null_weight(x)
      1 - Float(x)/Float(100)
    end

end
