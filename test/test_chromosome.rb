require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "chromosome"

class TestListChromosome < Test::Unit::TestCase

  def test_initialize
    chromosome = ListChromosome.new
    assert_equal([], chromosome.genes)
    chromosome = ListChromosome.new(Array.new(5))
    assert_equal(Array.new(5), chromosome.genes)
  end
  
  def test_random_init
    
  end

  def test_fitness
    
  end

  def test_crossover
    c = ListChromosome.new(Array.new(4))
    d = ListChromosome.new(Array.new(3))
    assert_raise(ArgumentError, "The size of the genes must be the same") { c.crossover(d) }
    d = ListChromosome.new(Array.new(4))
    assert_nothing_raised(ArgumentError, "No Exception must be thrown if size of genes is the same") { c.crossover(d)  }
    assert_equal(c.genes.size, c.crossover(d).genes.size, "The Childs genes must be the same size as the Parents")

    g = []
    h = []
    5.times do
       g << mock()
       h << mock()
    end
    c = ListChromosome.new(g)
    d = ListChromosome.new(h)
    child = c.crossover(d)
    puts child.genes.size
    child.genes.each_with_index { |gene, index| assert((gene == c.genes[index] or
      gene == d.genes[index]), "Gene at index #{index} isn't inherited.") }
  end

  def test_mutate
    return self
  end

end