require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "mutator"

class TestSingleMutator < Test::Unit::TestCase
  def test_mutate
    mutator = SingleMutator.new
    chromosome = mock()
    chromosome.expects(:size).returns(10)
    chromosome.expects(:mutate)
    mutator.mutate(chromosome)
  end
end

class TestProbabilityMutator < Test::Unit::TestCase

  def test_initialize
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(0)  }
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(1)  }
    assert_nothing_raised(ArgumentError) { ProbabilityMutator.new(0.5)  }
    assert_raise(ArgumentError) { ProbabilityMutator.new(2) }
    assert_raise(ArgumentError) { ProbabilityMutator.new("") }
  end

  def test_mutate
    chromosome = mock()
    chromosome.expects(:size).returns(10)
    chromosome.expects(:mutate).times(10)
    mutator = ProbabilityMutator.new(1)
    mutator.mutate(chromosome)

    chromosome = mock()
    chromosome.expects(:size).returns(10)
    mutator = ProbabilityMutator.new(0)
    mutator.mutate(chromosome)
  end

end
