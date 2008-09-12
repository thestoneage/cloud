$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'genetic'
require 'mutator'
require 'selector'
require 'weighted_knappsack'
require 'pp'
require 'java'

include_class 'java.awt.image.BufferedImage'
include_class 'javax.swing.JFrame'
include_class 'javax.swing.JPanel'
include_class 'java.awt.Dimension'
include_class 'java.awt.Color'
include_class 'java.awt.geom.Rectangle2D'


class MyPanel < JPanel
  
  attr_writer :image
  
  def initialize
    super
  end
  
  def paint(g)
    g.drawImage(@image, nil, 0, 0)
  end
end

w = 1000
h = 200
frame = JFrame.new("Live!")
panel = MyPanel.new
panel.setPreferredSize(Dimension.new(w, h))
frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE);
frame.add(panel)
frame.pack
frame.setVisible(true)

s = RandomSelector.new({ :elite_size => 1, :crossover_probability => 0.5, :mutation_probability => 0.25, :mutator => SingleMutator.new })
items = []
10.times { items << WeightedItem.new(22 + rand(30), 20 + rand(30))  }
f = WeightedKnappsackFactory.new(200, items )
g = Genetic.new(25, 100, f, s)
g.init_population

gap = 15
height = 50.0
maxweight = items.max {|a,b| a.weight <=> b.weight }.weight
maxweight = maxweight.to_f
vitems = []
colors = Hash.new
knapp = Rectangle2D::Double.new(0, 0, g.population.first.factory.size, height)
g.population.first.factory.items.each do |item|
  colors[item] = Color.new(rand(255), rand(255), rand(255))
  vitems << [ Rectangle2D::Double.new(0, 0, item.size, height * item.weight / maxweight), colors[item] ]
end
knapp_color = Color::LIGHT_GRAY
stroke_color = Color::WHITE


g.optimize do |gen, pop|
  frame.setTitle("(#{gen}. Generation) - Live!")
  image = BufferedImage.new(w, h, BufferedImage::TYPE_INT_RGB)
  graphics = image.createGraphics
  graphics.translate(gap, gap)
  startingpoint = graphics.getTransform
  graphics.setPaint(knapp_color)
  graphics.fill(knapp)
  graphics.setPaint(stroke_color)
  graphics.draw(knapp)
  graphics.translate(gap+knapp.width, 0)

  vitems.each do |item|
    graphics.setPaint(item[1])
    graphics.fill(item[0])
    graphics.setPaint(stroke_color)
    graphics.draw(item[0])
    graphics.translate(item[0].width + gap, 0)
  end
  graphics.translate(-vitems.inject(gap+knapp.width) {|n, i|  n+i[0].width+gap }, gap + height)

  graphics.setPaint(knapp_color)
  graphics.fill(knapp)
  graphics.setPaint(stroke_color)
  graphics.draw(knapp)
  
  left = graphics.getTransform
  graphics.translate(gap + knapp.width, 0)
  right = graphics.getTransform
  
  vitems.each_with_index do |item, index|
    graphics.setPaint(item[1])
    if (pop.first.genes[index])
      graphics.setTransform(left)
      graphics.fill(item[0])
      graphics.setPaint(stroke_color)
      graphics.draw(item[0])
      graphics.translate(item[0].width, 0)
      left = graphics.getTransform
    else
      graphics.setTransform(right)
      graphics.fill(item[0])
      graphics.setPaint(stroke_color)
      graphics.draw(item[0])
      graphics.translate(item[0].width + gap, 0)
      right = graphics.getTransform
    end
  end

  graphics.setTransform(startingpoint)
  graphics.translate(0, height+gap+height+gap)
  graphics.setPaint(knapp_color)
  graphics.fill( Rectangle2D::Double.new(0, 0, -pop.first.fitness, height ))
  graphics.setPaint(stroke_color)
  graphics.draw( Rectangle2D::Double.new(0, 0, -pop.first.fitness, height))

  
  panel.image = image
  panel.repaint
  sleep 0.005
end
g.population.reverse.each_with_index  do |chromosome, index|
  puts "Fitness #{chromosome.fitness}"
  pp chromosome.genes
  pp chromosome.factory.items
end

