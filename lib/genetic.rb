class Genetic
  
  attr_reader :population_size, :population, :max_generations, :generation, :chromosome_factory, :selector
  attr_writer :selector, :population
  
  def initialize(population_size, max_generations, chromosome_factory, selector)
    @population_size = population_size
    @max_generations = max_generations
    @generation = 0
    @chromosome_factory = chromosome_factory
    @selector = selector
  end

  def init_population
    @population = []
    @population_size.times do
      chromosome = chromosome_factory.get_chromosome
      chromosome.random_init
      chromosome.compute_fitness
      @population << chromosome
    end
    @population.sort!
    return @population
  end

  def optimize
    @max_generations.times do
      @generation += 1
      yield(@generation, @population) if block_given?
      @population = @selector.select_next_generation(@population)
#      @population.each { |chromosome| chromosome.compute_fitness }
      @population.sort!
    end 
    return @population
  end

end
