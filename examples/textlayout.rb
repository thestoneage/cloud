$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'

require 'pp'
require 'java'
include_class 'java.awt.Font'
include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.font.TextLayout'
include_class 'java.awt.Color'

class TextLayoutChromosome < ListChromosome

  attr_reader :fitness

  @@domain = nil
  @@metrics = nil
  @@width = 320
  @@height = 320

  def initialize(genes = [])
    super(genes)
    if (not @@domain)
      d = %w(simple beatiful random desaster interpreted small cool correct done beer coke caffine water pasta pancake apple crazy penis vagina)
      img = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
      graphics = img.createGraphics
      font = graphics.getFont()
      frc = graphics.getFontRenderContext()
      #metrics = graphics.getFontMetrics()
      @@domain = []
      d.each do |word|
        layout = TextLayout.new(word, font, frc);
        bounds = layout.getBounds()
        scale = rand*2+0.5
        @@domain << { :w => scale * bounds.getWidth, :h => scale * bounds.getHeight(), :str => word ,:scale  => scale}
      end
      #d.each { |word| @@domain << {:w => metrics.stringWidth(word), :h => metrics.getHeight(), :str => word} }
    end
  end

  def TextLayoutChromosome.domain
    return @@domain
  end

  def random_init
    color = [Color::blue, Color::red, Color::white]
    @@domain.each_index do |index|
      dom = @@domain[index]
      x = rand(@@width-dom[:w]*dom[:scale])
      y = rand(@@height-dom[:h]*dom[:scale])
      c = color[rand(color.size)]
      s = dom[:scale]
      @genes << Rectangle.new(x, y, dom[:w], dom[:h], dom[:str], c, s)
    end
    return @genes
  end

  def init_gene_at(index)
    gene = @genes[index]
    if (@fitness < (@@domain.size * @@width / 2.5))
      x = gene.x + (rand(10)-5)
      y = gene.y + (rand(10)-5)
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
      delta_x = ((one.x + one.w/2) - @@width/2).abs
      delta_y = ((one.y + one.h/2) - @@height/2).abs * 2
      @fitness +=  (delta_x + delta_y)
      @genes.each do |other|
        @fitness += 2 * (@@domain.size * @@width) if (one != other and one.intersects?(other))
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