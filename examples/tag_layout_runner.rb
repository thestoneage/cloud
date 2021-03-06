$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'genetic'
require 'mutator'
require 'selector'
require 'tag_layout'
require 'java'



include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.geom.Rectangle2D'
include_class 'javax.swing.JFrame'
include_class 'javax.swing.JPanel'
include_class 'java.awt.Dimension'
include_class 'java.awt.geom.AffineTransform'
include_class 'java.awt.font.TextLayout'

class MyPanel < JPanel
  
  attr_writer :image
  
  def initialize
    super
  end
  
  def paint(g)
    g.drawImage(@image, nil, 0, 0)
  end
end

width = 320
height = 200
frame = JFrame.new("Live!")
panel = MyPanel.new
panel.setPreferredSize(Dimension.new(width, height))
frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE);
frame.add(panel)
frame.pack
frame.setVisible(true)
#s = TruncationSelector.new({ :elite_size => 2, :crossover_probability => 0.95, :mutation_probability => 0.1, :truncation_percentage => 0.5, :mutator => ProbabilityMutator.new(0.2) })
s = RouletteSelector.new({ :elite_size => 2, :crossover_probability => 0.95, :mutation_probability => 0.2, :mutator => ProbabilityMutator.new(0.1) })
f = TagLayoutFactory.new(width, height)
g = Genetic.new(12, 1500, f, s)
g.init_population
g.optimize do |gen, pop| 
  str = "(#{gen}) "
  pop.each do |chromosome|
    str << "#{chromosome.fitness}; "
  end
  puts str
  frame.setTitle("(#{gen}. Generation) - Live!")
  image = BufferedImage.new(width, height, BufferedImage::TYPE_INT_RGB)
  graphics = image.createGraphics
  solution = pop.first
  at = AffineTransform.new
  solution.genes.each do |rect|
    graphics.setColor(rect.color)
#    shape = Rectangle2D::Double.new(rect.x, rect.y, rect.w, rect.h)
#    graphics.draw(shape)
    at = graphics.getTransform
    graphics.scale(rect.scale, rect.scale)
    font = graphics.getFont()
    frc = graphics.getFontRenderContext()
    layout = TextLayout.new(rect.str, font, frc);
    bounds = layout.getBounds()
    layout.draw(graphics, rect.x/rect.scale-bounds.getX.abs, rect.y/rect.scale-bounds.getY)
    graphics.setTransform(at)
  end
  panel.image = image
  panel.repaint
end
#frame.dispose
