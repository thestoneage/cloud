class Genetic
  
  attr_reader :population_size, :max_generations, :generation, :genome_type
  
  def initialize(population_size, max_generations, genome_type)
    @population_size = population_size
    @max_generations = max_generations
    @generation = 0
    @genome_type = genome_type
  end
  
  def init_population
    @population = []
    @population_size.times do 
      @population << genome_type.new
    end
    return @population
  end
  
end
