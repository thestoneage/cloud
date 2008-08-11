$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'

class GraphLayout < ListChromosome

  attr_reader :fitness

  @@domain = nil
  @@mindist = 50
  @@maxdist = 1000
  @@width = 320
  @@height = 200
  
  def initialize(genes = [])
    if (not @@domain)
      @@domain = Array.new(5) { Node.new(0, 0, 30) }
      @@domain[0].links << 1
      @@domain[0].links << 2
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
      delta_x = ((node.x + node.radius/2) - @@width/2).abs
      delta_y = ((node.y + node.radius/2) - @@height/2).abs
      @genes.each_with_index do |obj, index| 
       if node.distance(@genes[index]) > @@mindist
          @fitness += node.distance(@genes[index])
       else
         @fitness += @@maxdist*10
       end
      end
    end
    return @fitness
  end

end

class Node

  attr_reader :x, :y, :radius, :links

  def initialize(x, y, radius, links = [])
    @x = x
    @y = y
    @radius = radius
    @links = links
  end
  
  def distance(other)
#    puts "Distance self.x=#{self.x} self.y=#{self.y} and other.x=#{other.x} other.y=#{other.y}"
    x2 = ((self.x-other.x)**2)
    y2 = ((self.y-other.y)**2)
    return  Math.sqrt(x2+y2)
  end

end