$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'java'

include_class 'java.awt.geom.Line2D'
include_class 'java.awt.geom.Ellipse2D'
include_class 'java.awt.geom.Point2D'

class GraphLayout < ListChromosome

  attr_reader :fitness

  @@domain = nil
  @@mindist = 75
  @@maxdist = 1000
  @@width = 320
  @@height = 200
  
  def initialize(genes = [])
    if (not @@domain)
      @@domain = Array.new(5) { Node.new(0, 0, 30) }
      @@domain[0].links << 1
      @@domain[0].links << 2
      @@domain[0].links << 3
      @@domain[0].links << 4
      @@domain[3].links << 1
      @@domain[3].links << 4
    end
    super(genes)
  end

  def GraphLayout.domain
    return @@domain
  end

  def random_init
    @@domain.each_index do |index|
      @genes << self.init_gene_at(index)
    end
    return @genes
  end

  def init_gene_at(index)
    return Node.new(rand(@@width), rand(@@height), 30, @@domain[index].links)
  end

  def compute_fitness
    @fitness = 0
    @genes.each do |node|
      delta_x = ((node.x) - @@width/2).abs
      delta_y = ((node.y) - @@height/2).abs
      @genes.each do |other|
       if node != other and node.distance(other) < @@mindist
         @fitness += 100000000
       end
       
       node.links.each do |i|
         @fitness += node.distance(@genes[i])
         linea = Line2D::Double.new(node.x, node.y, @genes[i].x, @genes[i].y)
         other.links.each do |j|
           lineb = Line2D::Double.new(other.x, other.y, @genes[j].x, @genes[j].y)
           if linea.intersectsLine(lineb)
             @fitness += 100000000 
           end
           if lineb.intersects(node.shape.getBounds)
             @fitness += 100000000 unless (node == other or node == @genes[j])
           end
         end
       end
     end
   end
   return @fitness
 end

end

class Node

  attr_reader :x, :y, :radius, :links, :shape, :point

  def initialize(x, y, radius, links = [])
    @point = Point2D::Double.new(x, y)
    @shape = Ellipse2D::Double.new(x-radius/2.0, y-radius/2.0, radius, radius)
    @x = x
    @y = y
    @radius = radius
    @links = links
  end
  
  def distance(other)
    return  @point.distance(other.point)
  end

end

require 'Singleton'

class Domain include Singleton
  
  
  @@domain = nil
  private_class_method(:new)
  
  def Domain.getInstance()
    @@domain = new unless @@domain
    @@domain
  end
  
end