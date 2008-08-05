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
    #@image = BufferedImage.new(800, 600, BufferedImage::TYPE_INT_RGB)
    #@graphics = @image.createGraphics
  end

  def random_init
    @@domain.each do |element|
      @genes << Rectangle2D::Double.new(rand(400-element.first), rand(300-element.last), element.first, element.last)
    end
    return @genes
  end

  def mutate_gene_at index
    element = @@domain[index]
    @genes[index] = Rectangle2D::Double.new(rand(800 - element.first), rand(600 - element.last), element.first, element.last)
  end
  
  def compute_fitness
    @fitness = 0
    @genes.each do |gene|
      @genes.each do |other|
        @fitness += 1 if (gene != other and gene.intersects(other))
      end
    end
    return @fitness
  end

end