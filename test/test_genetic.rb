require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "genetic"

class TestGenetic < Test::Unit::TestCase

  def test_initialization
    population_size = 20
    generations = 10
    chromosome_factory = mock()
    selector = mock()
    genetic = Genetic.new(population_size, generations, chromosome_factory, selector)

    assert_equal(population_size, genetic.population_size)
    assert_equal(generations, genetic.max_generations)
    assert_equal(0, genetic.generation)
    assert_equal(selector, genetic.selector)
    assert_equal(chromosome_factory, genetic.chromosome_factory)
  end

  def test_case_init_population
    chromosome = mock()
    chromosome.expects(:random_init).times(10)
    chromosome.expects(:compute_fitness).times(10)
    chromosome.stubs(:<=>).returns(0)
    chromosome_factory = mock()
    chromosome_factory.expects(:get_chromosome).times(10).returns(chromosome)
    genetic = Genetic.new(10, 10, chromosome_factory, mock())

    genetic.init_population
    assert_equal(10, genetic.population.size)
    assert_equal(chromosome, genetic.population.first)
    assert_equal(chromosome, genetic.population.last)
  end
  
  def test_optimize
    selector = mock()
    chromosome = mock()
    genetic = Genetic.new(20, 10, mock(), selector)
    population = [chromosome]
    genetic.population = population
    selector.expects(:select_next_generation).times(10).returns(population)
    genetic.optimize
    assert_equal(10, genetic.generation)
  end

end

