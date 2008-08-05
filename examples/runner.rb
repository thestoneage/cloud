$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'genetic'
require 'mutator'
require 'selector'
require 'eigenlayout'
require 'pp'
require 'java'

include_class 'java.awt.image.BufferedImage'
include_class 'java.awt.geom.Rectangle2D'
include_class 'javax.imageio.ImageIO'

module JavaIO     
   include_package "java.io"
end

#s = RandomSelector.new({ :elite_size => 1, :crossover_probability => 0.5, :mutation_probility => 0.1 })
s = TruncationSelector.new({ :elite_size => 3, :crossover_probability => 0.95, :mutation_probability => 0.6, :truncation_percentage => 0.5, :mutator => ProbabilityMutator.new(0.1) })
g = Genetic.new(25, 1000, EigenLayoutChromosome, s)
g.init_population
p = g.optimize do |gen, pop| 
  str = "(#{gen}) "
  pop.each do |chromosome|
    str << "#{chromosome.fitness}; "
  end
  puts str
end
# 
image = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
graphics = image.createGraphics
solution = p.first
solution.genes.each do |rect|
  shape = Rectangle2D::Double.new(rect.x, rect.y, rect.w, rect.h)
  graphics.draw(shape)
end
outputfile = JavaIO::File.new("solution.png")
ImageIO.write(image, "png", outputfile)