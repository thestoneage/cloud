$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'

class EigenLayoutChromosome < ListChromosome

  attr_reader :fitness

  @@domain = nil
  @@width = 320
  @@height = 200

  def initialize(genes = [])
    super(genes)
    if (not @@domain)
      @@domain = []
      25.times { @@domain << [rand(10)+15, 10] }
    end
  end

  def EigenLayoutChromosome.domain
    return @@domain
  end

  def random_init
    @@domain.each_index do |index|
      @genes << self.init_gene_at(index)
    end
    return @genes
  end

  def init_gene_at(index)
    e = @@domain[index]
    return Rectangle.new(rand(@@width-e.first), rand(@@height-e.last), e.first, e.last)
  end


  def compute_fitness
    @fitness = 0
    @genes.each do |one|
      delta_x = ((one.x + one.w/2) - @@width/2).abs
      delta_y = ((one.y + one.h/2) - @@height/2).abs * (@@width / @@height)
      @fitness +=  (delta_x + delta_y)
      @genes.each do |other|
        @fitness += (@@domain.size * @@width) if (one != other and one.include_rectangle?(other))
      end
    end
    return @fitness
  end

end

class Rectangle
  
  attr_reader :x, :y, :w, :h
  
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @w = width
    @h = height
  end
  
  def include_point? a, b
    (self.x..self.x + self.w).include? a  and (self.y..self.y + self.h).include? b
  end
  
  def include_rectangle?(rect)
    return (self.include_point?(rect.x, rect.y) or
      self.include_point?(rect.x, rect.y + rect.h) or
      self.include_point?(rect.x + rect.w, rect.y) or
      self.include_point?(rect.x + rect.w, rect.y + rect.h))
  end
  
end