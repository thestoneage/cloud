$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'chromosome_factory'

require 'java'
include_class 'java.awt.Font'
include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.font.TextLayout'
include_class 'java.awt.Color'

class TagLayoutFactory < ChromosomeFactory

  attr_reader :fitness, :domain, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    d = %w(simple beatiful random desaster interpreted small cool correct done beer coke caffine water pasta pancake apple crazy)
    img = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
    graphics = img.createGraphics
    font = graphics.getFont()
    frc = graphics.getFontRenderContext()
    @domain = []
    d.each do |word|
      layout = TextLayout.new(word, font, frc)
      bounds = layout.getBounds()
      scale = rand*2+0.5
      @domain << { :w => scale * bounds.getWidth, :h => scale * bounds.getHeight(), :str => word ,:scale  => scale}
    end
  end
  
  def get_chromosome
    return TagLayout.new(self)
  end

end

class TagLayout < ListChromosome
  
  def initialize(factory, genes=[])
    super(genes)
    @factory = factory
  end

  def random_init
    color = [Color::blue, Color::red, Color::white]
    @factory.domain.each_index do |index|
      dom = @factory.domain[index]
      x = rand(@factory.width - dom[:w]*dom[:scale])
      y = rand(@factory.height - dom[:h]*dom[:scale])
      c = color[rand(color.size)]
      s = dom[:scale]
      @genes << Rectangle.new(x, y, dom[:w], dom[:h], dom[:str], c, s)
    end
    return @genes
  end

  def init_gene_at(index)
    gene = @genes[index]
    if (@fitness < (@factory.domain.size * @factory.width / 2.5))
      if (rand(2)==0)
        x = gene.x + (rand(@factory.width/10)+5)
        y = gene.y
      else
        y = gene.y + (rand(@factory.height/10)+5)
        x = gene.x
      end
    else
      xes = @genes.map { |e| e.x }
      max_x = xes.max
      min_x = xes.min
      yes = @genes.map { |e| e.y }
      max_y = yes.max
      min_y = yes.min
      x = rand(max_x - min_x)+min_x
      y = rand(max_y - min_y)+min_y
    end
    gene = Rectangle.new(x, y, gene.w, gene.h, gene.str, gene.color, gene.scale)
    return gene
  end

  def compute_fitness
    @fitness = 0
    @genes.each do |one|
      delta_x = ((one.x + one.w/2) - @factory.width/2).abs
      delta_y = ((one.y + one.h/2) - @factory.height/2).abs * 2
      @fitness +=  (delta_x + delta_y)
      @genes.each do |other|
        @fitness += 2 * (@factory.domain.size * @factory.width) if (one != other and one.intersects?(other))
      end
    end
    return @fitness
  end

end

class Rectangle

  attr_reader :x, :y, :w, :h, :str, :color, :scale
  attr_writer :x, :y
  
  def initialize(x, y, w, h, str, color, scale)
    @x = x
    @y = y
    @w = w
    @h = h
    @str = str
    @color = color
    @scale = scale
  end

  def intersects?(rect)
    return (rect.x + rect.w > self.x and
            rect.y + rect.h > self.y and
            rect.x < self.x + self.w and
            rect.y < self.y + self.h)
  end

end