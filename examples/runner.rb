$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'genetic'
require 'mutator'
require 'selector'
require 'layout'
require 'pp'
require 'java'
require 'profile'

include_class 'javax.imageio.ImageIO'

module JavaIO     
   include_package "java.io"
end

#s = RandomSelector.new({ :elite_size => 1, :crossover_probability => 0.5, :mutation_probility => 0.1 })
s = TruncationSelector.new({ :elite_size => 2, :crossover_probability => 0.8, :mutation_probability => 0.2, :truncation_percentage => 0.5, :mutator => ProbabilityMutator.new(0.1) })
g = Genetic.new(10, 10, LayoutChromosome, s)
g.init_population
population = g.optimize
solution = population.first
image = BufferedImage.new(320, 200, BufferedImage::TYPE_INT_RGB)
graphics = image.createGraphics
solution.genes.each do |shape|
  graphics.draw(shape)
end
outputfile = JavaIO::File.new("solution.png")
ImageIO.write(image, "png", outputfile)