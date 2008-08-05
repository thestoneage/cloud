$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'java'

include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.geom.Rectangle2D'

class LayoutChromosome < ListChromosome

  attr_reader :fitness
  
  @@domain = nil
  
  def initialize(genes = [])
    super(genes)
    if (not @@domain)
      @@domain = []
      75.times { @@domain << [rand(10)+15, 10] }
    end
  end
  
  def LayoutChromosome.domain
    return @@domain
  end

  def random_init
    @@domain.each_index do |index|
      @genes << self.init_gene_at(index)
    end
    return @genes
  end
  
  def init_gene_at(index)
    element = @@domain[index]
    return Rectangle2D::Double.new(rand(320-element.first), rand(200-element.last), element.first, element.last)
  end

  def compute_fitness
    if @fitness
      return @fitness
    else
      @fitness = 0
      @genes.each_index do |i|
        @genes[i, @genes.size].each_index do |j|
          @fitness += 1 if (@genes[i] != @genes[j] and @genes[i].intersects(@genes[j]))
        end
      end
      return @fitness
    end
  end

end