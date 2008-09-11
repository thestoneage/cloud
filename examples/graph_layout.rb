$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'chromosome_factory'
require 'java'

include_class 'java.awt.geom.Line2D'
include_class 'java.awt.geom.Ellipse2D'
include_class 'java.awt.geom.Point2D'

class GraphLayoutFactory < ChromosomeFactory

  attr_reader :width, :height, :mindist, :domain

  def initialize(width, height)
    @width = width
    @height = height
    @mindist = 75
    
    @domain = Array.new(5) { Array.new }
    @domain[0] << @domain[1]
    @domain[0] << @domain[2]
    @domain[0] << @domain[3]
    @domain[0] << @domain[4]
    @domain[3] << @domain[1]
    @domain[3] << @domain[4]
  end
  
  def get_chromosome
    return GraphLayout.new(self)
  end

end

class GraphLayout < ListChromosome

  attr_reader :fitness

  
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
    return Node.new(@factory.domain, rand(@factory.width), rand(@factory.height), 30)
  end

  def compute_fitness
    @fitness = 0
    @genes.each do |node|
      @fitness += node.distance_from_center(@factory.width, @factory.height )
      @genes.each do |other|
       if node != other and node.distance(other) < @factory.mindist
         @fitness += 100000000
       else
         @fitness += node.distance(other)
       end
       
     end
   end
   return @fitness
 end

end

class Node

  attr_reader :x, :y, :radius, :links, :shape, :point, :domnode

  def initialize(domain, x, y, radius)
    @domain = domain
    @point = Point2D::Double.new(x, y)
    @shape = Ellipse2D::Double.new(x-radius/2.0, y-radius/2.0, radius, radius)
    @x = x
    @y = y
    @radius = radius
    @links = []
  end
  
  def distance(other)
    return  @point.distance(other.point)
  end
  
  def distance_from_center(width, height)
    dx = (@x - width).abs
    dy = (@y - height).abs
    return (dx + dy)
  end

end
