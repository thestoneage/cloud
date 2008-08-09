require 'mutator'
require 'pp'
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

  def genetic_operators(candidate, partner)
    if (rand <= @crossover_probability)
      candidate = candidate.crossover(partner)
      candidate.compute_fitness
    end
    if (rand <= @mutation_probability)
      candidate = candidate.mutate(@mutator)
      candidate.compute_fitness
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
      cand = self.select_candidate(population)
      part = self.select_candidate(population)
      next_gen << self.genetic_operators(cand, part)
    end
    return next_gen
  end

  def select_candidate(population)
    return population[rand(population.size)]
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
    while next_gen.size < population.size
      cand = select_candidate(population, truncation_index)
      part = select_candidate(population, truncation_index)
      next_gen << self.genetic_operators(cand, part)
    end
    return next_gen
  end

  def select_candidate(population, truncation_index)
    candidates = population[0, truncation_index]
    return candidates[rand(candidates.size)]
  end

end

class RouletteSelector < Selector

  def initialize(args = {})
    super(args)
  end

  def select_next_generation(population)
    next_gen = super(population)
    xfit = population.map { |x| 1.0/(x.fitness+1) }
    sum = xfit.inject { |s, n| s+n }
    psum = 0
    probmap = xfit.map { |x| psum += x / sum.to_f }
    while  next_gen.size < population.size
      cand = select_candidate(probmap, population)
      part = select_candidate(probmap, population)
      next_gen << self.genetic_operators(cand, part)
    end
    return next_gen
  end

  def select_candidate(probmap, population)
    random = rand
    index = probmap.index(probmap.find { |x| x > random })
    return population[index]
  end

end

class TournamentSelector < Selector
  
  def initialize(args={})
    super(args)
    if args[:tournament_percentage]
       @tournament_percentage = args[:tournament_percentage]
       raise(ArgumentError, "Tournament Percentage must be between 0 and 1") unless
         (0 <= @tournament_percentage and @tournament_percentage <= 1)
     else
       @turnament_percentage = 1
     end
     if args[:tournament_selection_probability]
       @tournament_selection_probability = args[:tournament_selection_probability]
       raise(ArgumentError, "tournament_selection_probabiltiy must be between 0 and 1") unless
         (0 <= @tournament_selection_probability and @tournament_selection_probability <= 1)
     else
       @tournament_selection_probability = 0.75
     end
  end

  def select_next_generation(population)
    next_gen = super(population)
    size = [1, (population.size * @tournament_percentage).round].max
    probmap = Array.new(size) { |i| @tournament_selection_probabiltiy * (1 - @tournament_selection_probabiltiy)**i }
    sum = probmap.inject { |s, e| s+e }
    probmap.map! { |e| e/sum.to_f }
    psum = 0
    probmap.map! { |x| psum += x }
    while  next_gen.size < population.size
      cand = select_candidate(population, probmap)
      part = select_candidate(population, probmap)
      next_gen << self.genetic_operators(cand, part)
    end
    return next_gen
  end

  def select_candidate(population, probmap)
    tournament = []
    while turnament.size < probmap.size
      tournament << population[rand(probmap.size)]
    end
    tournament.sort!
    random = rand
    index = probmap.index(probmap.find { |x| x > random })
    return population[index]
  end

end
