$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'genetic'
require 'selector'
require 'layout'
require 'pp'

s = RandomSelector.new({ :elite_size => 1, :crossover_probability => 0.8, :mutation_probility => 0.05 })
s = TruncationSelector.new({ :elite_size => 1, :crossover_probability => 0.8, :mutation_probability => 0.3, :truncation_percentage => 0.3 })
g = Genetic.new(20, 30, LayoutChromosome, s)
g.init_population
g.optimize