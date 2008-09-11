$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'genetic'
require 'mutator'
require 'selector'
require 'graph_layout'
require 'java'

include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.geom.Ellipse2D'
include_class 'java.awt.geom.Line2D'
include_class 'javax.swing.JFrame'
include_class 'javax.swing.JPanel'
include_class 'java.awt.Dimension'
include_class 'java.awt.font.TextLayout'
include_class 'java.awt.RenderingHints'
include_class 'java.awt.BasicStroke'
include_class 'java.awt.Color'

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
rh =  RenderingHints.new(RenderingHints.new(RenderingHints::KEY_ANTIALIASING, RenderingHints::VALUE_ANTIALIAS_ON))
rh.add(RenderingHints.new(RenderingHints::KEY_TEXT_ANTIALIASING, RenderingHints::VALUE_TEXT_ANTIALIAS_ON))

s = RouletteSelector.new({ :elite_size => 1, :crossover_probability => 0.0, :mutation_probability => 0.0, :mutator => SingleMutator.new })
f = GraphLayoutFactory.new(width, height)
g = Genetic.new(4, 150, f, s)

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
  graphics.setRenderingHints(rh);
  graphics.setStroke(BasicStroke.new(2.5))
  solution = pop.first
  solution.genes.each do |node|
    node.domnode.each do |other|
      if (node.domnode)
     line = Line2D::Double.new(node.point, other.point)
     graphics.draw(line)
    end
  end
  solution.genes.each do |node|
   graphics.setColor(Color::black)
   graphics.fill(node.shape)
   graphics.setColor(Color::white)
   graphics.draw(node.shape)
  end
  panel.image = image
  panel.repaint
end
frame.dispose
