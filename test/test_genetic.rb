require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "genetic"

class TestGeneticAlgorithem < Test::Unit::TestCase

  def test_initialization
    population_size = 20
    generations = 10
    genome_type = mock()
    selector = mock()
    genetic = Genetic.new(population_size, generations, genome_type, selector)

    assert_equal(population_size, genetic.population_size)
    assert_equal(generations, genetic.max_generations)
    assert_equal(0, genetic.generation)
    assert_equal(selector, genetic.selector)
    assert_equal(genome_type, genetic.chromosome_type)
  end

  def test_case_init_population
    genome_type = mock()
    genome = mock()
    genome.expects(:random_init).times(10)
    genome_type.expects(:new).times(10).returns(genome)
    genetic = Genetic.new(10, 10, genome_type, mock())
    genetic.init_population
    assert_equal(10, genetic.population.size)
    assert_equal(genome, genetic.population.first)
    assert_equal(genome, genetic.population.last)
  end
  
  def test_optimize
    selector = mock()
    chromosome = mock()
    chromosome.expects(:compute_fitness).times(11)
    chromosome.expects(:fitness).times(10)
    genetic = Genetic.new(20, 10, mock(), selector)
    population = [chromosome]
    genetic.population = population
    selector.expects(:select_next_generation).times(10).returns(population)
    genetic.optimize
    assert_equal(10, genetic.generation)
  end

end

