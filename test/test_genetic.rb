require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "genetic"

class TestGeneticAlgorithem < Test::Unit::TestCase
  
  def test_initialization
    population_size = 20
    generations = 10
    genome_type = mock()
    genome_type.expects(:class).returns(Class)
    genetic = Genetic.new(population_size, generations, genome_type)

    assert_equal(population_size, genetic.population_size)

    assert_equal(generations, genetic.max_generations)

    assert_equal(0, genetic.generation)

    assert(genetic.genome_type.class == Class, "Genome Type is no Class Object.")
  end

  def test_case_init_population
    genome_type = mock()
    genome_type.expects(:new).times(10)
    genetic = Genetic.new(10, 10, genome_type)
    assert_equal(10, genetic.init_population.size)
  end
  
end
