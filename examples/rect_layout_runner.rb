$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'genetic'
require 'mutator'
require 'selector'
require 'eigenlayout'
require 'pp'
require 'java'

include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.geom.Rectangle2D'
include_class 'javax.swing.JFrame'
include_class 'javax.swing.JPanel'
include_class 'java.awt.Dimension'

class MyPanel < JPanel
  
  attr_writer :image
  
  def initialize
    super
  end
  
  def paint(g)
    g.drawImage(@image, nil, 0, 0)
  end
  
end
frame = JFrame.new("Live!")
panel = MyPanel.new
panel.setPreferredSize(Dimension.new(320, 200))
frame.add(panel)
frame.pack
frame.setVisible(true)
selector = TruncationSelector.new({ :elite_size => 1, :crossover_probability => 0.5, :mutation_probability => 0.1, :truncation_percentage => 0.5, :mutator => ProbabilityMutator.new(0.2) })
factory = EigenLayoutFactory.new
genetic = Genetic.new(12, 300, factory, selector)
genetic.init_population
p = genetic.optimize do |gen, pop|
  str = "(#{gen}) "
  pop.each do |chromosome|
    str << "#{chromosome.fitness}; "
  end
  puts str
  frame.setTitle("(#{gen}. Generation) - Live!")
  image = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
  graphics = image.createGraphics
  solution = pop.first
  solution.genes.each do |rect|
    shape = Rectangle2D::Double.new(rect.x, rect.y, rect.w, rect.h)
    graphics.draw(shape)
  end
  panel.image = image
  panel.repaint
end
