require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "chromosome"

class TestListChromosome < Test::Unit::TestCase

  def setup
    @empty_chromosome = ListChromosome.new
  end

  def test_initialize
    assert_equal([], @empty_chromosome.genes)
    chromosome = ListChromosome.new(Array.new(5))
    assert_equal(Array.new(5), chromosome.genes)
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
    child.genes.each_with_index { |gene, index| assert((gene == c.genes[index] or
      gene == d.genes[index]), "Gene at index #{index} isn't inherited.") }
  end

  def test_size
    assert(@empty_chromosome.size == 0, "Empty Chromosome must have a size of 0.")
    c = ListChromosome(Array.new(5))
    assert(c.size = 5, "Size of Chromosome must be 5.")
  end

  def test_mutate
    chromos1 = ListChromosome.new
    mutator = mock
    mutator.expects(:mutate).with(chromos1).returns([])
    chromos2 = chromos1.mutate(mutator)
    assert(chromos2.class == chromos1.class, "The mutated Chromosome must have the sam class as the original one.")
    assert_equal(chromos1.genes, chromos2.genes, "Since we mock the mutator both Chromosomes must be equal.")
  end

  def test_size
    assert_equal(0, @empty_chromosome.size, "Size of an empty Chromosome should be 0.")
  end

end