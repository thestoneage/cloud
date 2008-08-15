$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'chromosome_factory'

class EigenLayoutFactory < ChromosomeFactory

  attr_reader :domain, :width, :height

  def initialize
    @domain = []
    @width = 320
    @height = 200
    25.times { @domain << [rand(10)+15, 10] }
  end
  
  def get_chromosome
    return EigenLayout.new(self)
  end

end

class EigenLayout < ListChromosome

  def initialize(factory, genes = [])
    super(genes)
    @factory = factory
  end

  def random_init
    @factory.domain.each_index do |index|
      @genes << self.init_gene_at(index)
    end
    return @genes
  end

  def init_gene_at(index)
    e = @factory.domain[index]
    return Rectangle.new(rand(@factory.width-e.first), rand(@factory.height-e.last), e.first, e.last)
  end

  def compute_fitness
    @fitness = 0
    @genes.each do |one|
      w = @factory.width
      h = @factory.height
      delta_x = ((one.x + one.w/2) - w/2).abs
      delta_y = ((one.y + one.h/2) - h/2).abs * (w / h)
      @fitness +=  (delta_x + delta_y)
      @genes.each do |other|
        @fitness += (@factory.domain.size * w) if (one != other and one.include_rectangle?(other))
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