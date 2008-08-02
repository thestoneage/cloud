require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "selector"

class TestSelector < Test::Unit::TestCase

  def setup
    @selector = Selector.new
  end

  def test_initialize
    assert_raise(ArgumentError) { Selector.new(1.0) }
    assert_raise(ArgumentError) { Selector.new(-1) }
    assert_nothing_raised(ArgumentError) { Selector.new(0)}
  end
  
  def test_select_next_generation
    selector = Selector.new(10)
    assert_raise(ArgumentError) { selector.select_next_generation(Array.new(5)) }
    assert_nothing_raised(ArgumentError) { selector.select_next_generation(Array.new(10))}

    population = Array.new(5)
    selector = Selector.new(3)
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(selector.elite_size == next_gen.size, "Length of the Array should be Number of Elitist to keep")
    assert(next_gen == Array.new(selector.elite_size), "Should return the Elite")
  end
  
end

class TestRandomSelector < Test::Unit::TestCase

  def setup
    @selector = RandomSelector.new(0, 1.0)
  end

  def test_initialize
    assert_raise(ArgumentError) { RandomSelector.new(0, 2, 0.0) }
    assert_raise(ArgumentError) { RandomSelector.new(0, 0.0, 2) }
    assert_raise(ArgumentError) { RandomSelector.new(0, -0.1, 0.0) }
    assert_raise(ArgumentError) { RandomSelector.new(0, 0.0, -0.1) }
    assert_nothing_raised(ArgumentError) { RandomSelector.new(0, 0.5, 0.5) }
    assert_nothing_raised(ArgumentError) { RandomSelector.new(0, 1, 1) }
    assert_nothing_raised(ArgumentError) { RandomSelector.new(0, 0, 0) }
  end
  
  def test_select_next_generation
    population = Array.new(5)
    selector = RandomSelector.new(5, 0.5, 0.0)
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(next_gen == population, "If Elite has size of population, the next generation is the same as the population.")

    selector = RandomSelector.new(0, 0.0, 0.0)
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(population == next_gen, "With a Crossover Probability of 0.0 the next Generation is the same as the Population")

    selector = RandomSelector.new(0, 1.0, 0.0)
    ca = mock()
    ca.expects(:crossover).times(3).with(ca).returns(:ca)
    population = [ca, ca, ca]
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(next_gen == [:ca, :ca, :ca], "With Crossover Probability of 1.0 the next Generation will be only the stubs")
    
    selector = RandomSelector.new(0, 0.0, 1.0)
    cb = mock()
    cb.expects(:mutate).times(3).returns(:cb)
    population = [cb, cb, cb]
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(next_gen == [:cb, :cb, :cb], "With Mutation Probability of 1.0 the next Generation will be only the stubs")
  end

end