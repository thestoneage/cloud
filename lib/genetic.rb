class Genetic
  
  attr_reader :population_size, :population, :max_generations, :generation, :chromosome_type, :selector
  attr_writer :selector, :population
  
  def initialize(population_size, max_generations, chromosome_type, selector)
    @population_size = population_size
    @max_generations = max_generations
    @generation = 0
    @chromosome_type = chromosome_type
    @selector = selector
  end

  def init_population
    @population = []
    @population_size.times do
      chromosome = chromosome_type.new
      chromosome.random_init
      @population << chromosome
    end
    return @population
  end

  def optimize
    @max_generations.times do
      @population.each { |chromosome| chromosome.compute_fitness }
      @population = @population.sort_by { |chromosome| chromosome.fitness }
      @population = @selector.select_next_generation(@population)
      @generation += 1
    end 
    @population.each { |chromosome| chromosome.compute_fitness }
    @population = @population.sort_by { |chromosome| chromosome.fitness }
    return @population  
  end

end
