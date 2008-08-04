require 'mutator'

class Selector
  
  attr_reader :elite_size
  
  def initialize(elite_size = 0)
    raise(ArgumentError, "elite_size must be an non negative Integer") unless (elite_size.class == Fixnum and elite_size >= 0)
    @elite_size = elite_size
  end
  
  def select_next_generation(population)
    if @elite_size > population.size
      raise ArgumentError, "Size of Elite (#{@elite_size}) > Size of Population (#{population.size})"
    end
    next_gen = []
    elite_size.times { |index| next_gen << population[index] }
    return next_gen
  end

end

class RandomSelector < Selector

  def initialize(elite_size = 0, crossover_probability = 0.3, mutation_probability = 0.05, mutator = SingleMutator.new)
    super(elite_size)
    raise(ArgumentError, "Crossover Probabilities must be between 0 and 1") unless 
      (0 <= crossover_probability and crossover_probability <= 1) and
      (0 <= mutation_probability and mutation_probability <= 1)
    raise(ArgumentError, "Mutator Type required!") unless (mutator.respond_to? :mutate)
    @crossover_probability = crossover_probability
    @mutation_probability = mutation_probability
    @mutator = mutator
  end

  def select_next_generation(population)
    next_gen = super(population)
    puts @mutation_probability
    while next_gen.size < population.size
      candidate = population[rand(population.size)]
      if (rand <= @crossover_probability)
        candidate = candidate.crossover(population[rand(population.size)])
      end
      if (rand <= @mutation_probability)
        candidate = @mutator.mutate(candidate)
      end
      next_gen << candidate 
    end
    return next_gen
  end
end
