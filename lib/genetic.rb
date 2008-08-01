class Genetic
  
  attr_reader :population_size, :population, :max_generations, :generation, :genome_type, :selector
  attr_writer :selector, :population
  
  def initialize(population_size, max_generations, genome_type, selector)
    @population_size = population_size
    @max_generations = max_generations
    @generation = 0
    @genome_type = genome_type
    @selector = selector
  end

  def init_population
    @population = []
    @population_size.times do
      genome = genome_type.new
      genome.random_init
      @population << genome
    end
    return @population
  end

  def optimize
    @max_generations.times do
      compute_fitness
      @selector.select
    end 
  end

  def compute_fitness
    @population.each { |chromosome| chromosome.compute_fitness }
  end

end
