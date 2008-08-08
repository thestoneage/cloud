$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'

require 'pp'
require 'java'
include_class 'java.awt.Font'
include_class 'java.awt.image.BufferedImage'

class TextLayout < ListChromosome

  attr_reader :fitness

  @@domain = nil
  @@metrics = nil
  @@width = 320
  @@height = 320

  def initialize(genes = [])
    super(genes)
    if (not @@domain)
      d = %w(simple beatiful random desaster interpreted small cool correct done beer coke caffine water pasta pancake apple)
      img = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
      graphics = img.createGraphics
      metrics = graphics.getFontMetrics();
      @@domain = []
      d.each { |word| @@domain << {:w => metrics.stringWidth(word), :h => metrics.getHeight(), :str => word} }
    end
  end

  def TextLayout.domain
    return @@domain
  end

  def random_init
    @@domain.each_index do |index|
      @genes << self.init_gene_at(index)
    end
    return @genes
  end

  def init_gene_at(index)
    dom = @@domain[index]
    if (@fitness and @fitness < @@domain.size * @@width / 2)
      gene = @genes[index]
      x = gene.x + (rand(10)-5)
      y = gene.y + (rand(10)-5)
    else
      if @genes and @genes.size == @@domain.size
        xes = @genes.map { |e| e.x }
        max_x = xes.max
        min_x = xes.min
        yes = @genes.map { |e| e.y }
        max_y = yes.max
        min_y = yes.min
        x = rand(max_x - min_x)+min_x
        y = rand(max_y - min_y)+min_y
      else 
        x = rand(@@width-dom[:w])
        y = rand(@@height-dom[:h])
      end
    end
    gene = Rectangle.new(x, y, dom[:w], dom[:h], dom[:str])
    return gene
  end

  def compute_fitness
    @fitness = 0
    @genes.each do |one|
      delta_x = ((one.x + one.w/2) - @@width/2).abs * 2
      delta_y = ((one.y + one.h/2) - @@height/2).abs * 2
      @fitness +=  (delta_x + delta_y)
      @genes.each do |other|
        @fitness += (@@domain.size * @@width) if (one != other and one.include_rectangle?(other))
      end
    end
    return @fitness
  end

end

class Rectangle

  attr_reader :x, :y, :w, :h, :str
  attr_writer :x, :y
  
  def initialize(x, y, w, h, str)
    @x = x
    @y = y
    @w = w
    @h = h
    @str = str
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