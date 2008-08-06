require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "mutator"

class TestSingleMutator < Test::Unit::TestCase
  def test_mutate
    mutator = SingleMutator.new
    chromosome = mock()
    chromosome.expects(:size).returns(10)
    index = mutator.mutate(chromosome)
    assert(index.class == Array, "An Array muste be returned.")
    assert(index.size == 1, "Array must have Size 1.")
  end
end

class TestProbabilityMutator < Test::Unit::TestCase

  def test_initialize
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(0)  }
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(1)  }
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(0.5)  }
    assert_raise(ArgumentError) { ProbabilityMutator.new(2) }
    assert_raise(ArgumentError) { ProbabilityMutator.new(-1) }
    assert_raise(ArgumentError) { ProbabilityMutator.new("") }
  end

  def test_mutate
    chromosome = mock()
    chromosome.expects(:size).returns(10)
    mutator = ProbabilityMutator.new(1)
    indices = mutator.mutate(chromosome)
    assert_equal(Array, indices.class)
    assert_equal(10, indices.size)

    chromosome = mock()
    chromosome.expects(:size).returns(10)
    mutator = ProbabilityMutator.new(0)
    indices = mutator.mutate(chromosome)
    assert_equal(Array, indices.class)
    assert_equal(0, indices.size)
  end

end
