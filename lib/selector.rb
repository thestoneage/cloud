require 'mutator'

class Selector

  def initialize(args = {})
    raise(ArgumentError) unless args.class == Hash
    if args[:elite_size]
      @elite_size = args[:elite_size]
      raise(ArgumentError, ":elite_size must be an non negative Integer") unless (@elite_size.class == Fixnum and @elite_size >= 0)
    else
      @elite_size = 0
    end
    if args[:mutator]
      @mutator = args[:mutator]
      raise(ArgumentError, "Mutator Type required!") unless (@mutator.respond_to? :mutate)
    else
      @mutator = SingleMutator.new
    end
    if args[:crossover_probability]
      @crossover_probability = args[:crossover_probability]
      raise(ArgumentError, "Crossover Probabilities must be between 0 and 1") unless
        (0 <= @crossover_probability and @crossover_probability <= 1)
    else
      @crossover_probability = 0
    end
    if args[:mutation_probability]
      @mutation_probability = args[:mutation_probability]
      raise(ArgumentError, "Mutation Probabilities must be between 0 and 1") unless
        (0 <= @mutation_probability and @mutation_probability <= 1)
    else
      @mutation_probability = 0
    end
  end

  def select_next_generation(population)
    if @elite_size > population.size
      raise ArgumentError, "Size of Elite (#{@elite_size}) > Size of Population (#{population.size})"
    end
    next_gen = []
    @elite_size.times { |index| next_gen << population[index] }
    return next_gen
  end

  def genetic_operators(candidate, partners)
    if (rand <= @crossover_probability)
      candidate = candidate.crossover(partners[rand(partners.size)])
    end
    if (rand <= @mutation_probability)
      candidate = candidate.mutate(@mutator)
    end
    return candidate
  end
end

class RandomSelector < Selector

  def initialize(args = {})
    super(args)
  end

  def select_next_generation(population)
    next_gen = super(population)
    while next_gen.size < population.size
      candidate = population[rand(population.size)]
      next_gen << self.genetic_operators(candidate, population)
    end
    return next_gen
  end

end

class TruncationSelector < Selector

  def initialize(args = {})
    super(args)
    if args[:truncation_percentage]
      @truncation_percentage = args[:truncation_percentage]
      raise(ArgumentError, "Truncation Percentage must be between 0 and 1") unless
        (0 <= @truncation_percentage and @truncation_percentage <= 1)
    else
      @truncation_percentage = 0
    end
  end

  def select_next_generation(population)
    next_gen = super(population)
    truncation_index = [1, (@truncation_percentage * population.size).round].max
    candidates = population[0, truncation_index]
    while next_gen.size < population.size
      candidate = candidates[rand(candidates.size)]
      next_gen << self.genetic_operators(candidate, candidates)
    end
    return next_gen
  end

end