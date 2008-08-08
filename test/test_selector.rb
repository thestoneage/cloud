require File.join(File.dirname(__FILE__), 'cloud_test_helper')

require "selector"

class TestSelector < Test::Unit::TestCase

  def test_initialize
    assert_raise(ArgumentError) { Selector.new(mock()) }
    assert_nothing_raised(ArgumentError) { Selector.new({}) }
    assert_raise(ArgumentError) { Selector.new({:elite_size => -1}) }
    assert_raise(ArgumentError) { Selector.new({:elite_size => 2.0}) }
    assert_raise(ArgumentError) { Selector.new({:elite_size => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:elite_size => 0})}
    assert_nothing_raised(ArgumentError) { Selector.new({:elite_size => 1})}
    assert_raise(ArgumentError) { Selector.new({:mutator => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:mutator => SingleMutator.new})}
    assert_raise(ArgumentError) { Selector.new({:crossover_probability => 1.1}) }
    assert_raise(ArgumentError) { Selector.new({:crossover_probability => -0.1}) }
    assert_raise(ArgumentError) { Selector.new({:crossover_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 0 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 1 })}

    assert_raise(ArgumentError) { Selector.new({:mutation_probability => 1.1}) }
    assert_raise(ArgumentError) { Selector.new({:mutation_probability => -0.1}) }
    assert_raise(ArgumentError) { Selector.new({:mutation_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 0 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 1 })}
  end

  def test_select_next_generation
    selector = Selector.new({:elite_size => 10})
    assert_raise(ArgumentError) { selector.select_next_generation(Array.new(5)) }
    assert_nothing_raised(ArgumentError) { selector.select_next_generation(Array.new(10))}
    population = Array.new(5)
    es = 3
    selector = Selector.new({:elite_size => es})
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(es == next_gen.size, "Length of the Array should be Number of Elitist to keep")
    assert(next_gen == Array.new(es), "Should return the Elite")
  end

  def test_genetic_operators
    selector = Selector.new
    candidate = mock()
    population = mock()
    assert_equal(candidate, selector.genetic_operators(candidate, population))
  end
end

class TestRandomSelector < Test::Unit::TestCase

  def test_initialize
    assert_raise(ArgumentError) { Selector.new(mock()) }

    assert_nothing_raised(ArgumentError) { Selector.new({}) }

    assert_raise(ArgumentError) { Selector.new({:elite_size => -1}) }
    assert_raise(ArgumentError) { Selector.new({:elite_size => 2.0}) }
    assert_raise(ArgumentError) { Selector.new({:elite_size => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:elite_size => 0})}
    assert_nothing_raised(ArgumentError) { Selector.new({:elite_size => 1})}

    assert_raise(ArgumentError) { Selector.new({:mutator => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:mutator => SingleMutator.new})}

    assert_raise(ArgumentError) { Selector.new({:crossover_probability => 1.1}) }
    assert_raise(ArgumentError) { Selector.new({:crossover_probability => -0.1}) }
    assert_raise(ArgumentError) { Selector.new({:crossover_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 0 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:crossover_probability => 1 })}

    assert_raise(ArgumentError) { Selector.new({:mutation_probability => 1.1}) }
    assert_raise(ArgumentError) { Selector.new({:mutation_probability => -0.1}) }
    assert_raise(ArgumentError) { Selector.new({:mutation_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 0 })}
    assert_nothing_raised(ArgumentError) { Selector.new({:mutation_probability => 1 })}
  end

  def test_select_next_generation
    population = Array.new(5)
    selector = RandomSelector.new({:elite_size => 5})
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(next_gen == population, "If Elite has size of population, the next generation is the same as the population.")

    selector = RandomSelector.new()
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(population == next_gen, "With a Crossover Probability of 0.0 the next Generation is the same as the Population")

    selector = RandomSelector.new({:crossover_probability => 1})
    ca = mock()
    ca.expects(:crossover).times(3).with(ca).returns(:ca)
    population = [ca, ca, ca]
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(next_gen == [:ca, :ca, :ca], "With Crossover Probability of 1.0 the next Generation will be only the stubs")

    selector = RandomSelector.new({:mutation_probability => 1})
    cb = mock()
    cb.expects(:mutate).times(3).returns(:cb)
    population = [cb, cb, cb]
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    assert(next_gen == [:cb, :cb, :cb], "With Mutation Probability of 1.0 the next Generation will be only the stubs")
  end

end

class TestTruncationSelector < Test::Unit::TestCase

  def test_initialize
    assert_raise(ArgumentError) { TruncationSelector.new(mock()) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:elite_size => -1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:elite_size => 2.0}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:elite_size => mock()}) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:elite_size => 0})}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:elite_size => 1})}
    assert_raise(ArgumentError) { TruncationSelector.new({:mutator => mock()}) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:mutator => SingleMutator.new})}
    assert_raise(ArgumentError) { TruncationSelector.new({:crossover_probability => 1.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:crossover_probability => -0.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:crossover_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:crossover_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:crossover_probability => 0 })}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:crossover_probability => 1 })}

    assert_raise(ArgumentError) { TruncationSelector.new({:mutation_probability => 1.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:mutation_probability => -0.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:mutation_probability => mock()}) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:mutation_probability => 0.1 })}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:mutation_probability => 1 })}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new({:mutation_probability => 0 })}

    assert_raise(ArgumentError) { TruncationSelector.new({:truncation_percentage => 1.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:truncation_percentage => -0.1}) }
    assert_raise(ArgumentError) { TruncationSelector.new({:truncation_percentage => mock()}) }
    assert_nothing_raised(ArgumentError) { TruncationSelector.new(:truncation_percentage => 0)}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new(:truncation_percentage => 1)}
    assert_nothing_raised(ArgumentError) { TruncationSelector.new(:truncation_percentage => 0.1)}
  end

  def test_select_next_generation
    population = []
    5.times { population << mock() }
    selector = TruncationSelector.new( {:truncation_percentage => 1} )
    next_gen = selector.select_next_generation(population)
    assert(next_gen.class == Array, "Return Type should be an Array")
    assert(population.size == next_gen.size, "Population and Next Generation must have the same size")
    next_gen.each { |element| assert(population.include?(element), "Element must be in population") }

    selector = TruncationSelector.new( {:truncation_percentage => 0} )
    next_gen = selector.select_next_generation(population)
    next_gen.each { |element| assert(element == population.first, "Each element must be the first")}

    selector = TruncationSelector.new( {:truncation_percentage => 0.5} )
    next_gen = selector.select_next_generation(population)
    next_gen.each { |element| assert(population[0, 5].include?(element), "Element must be in first 5 of the Population")}

  end

end

class TestRouletteSelector < Test::Unit::TestCase
  def test_initilization
    assert_nothing_raised(ArgumentError) { RouletteSelector.new }
  end

  def test_select_next_generation
    selector = RouletteSelector.new()
    chromosome = mock()
    chromosome.stubs(:fitness).returns(1)
    population = Array.new(5)
    population.fill(chromosome)
    next_gen = selector.select_next_generation(population)
    assert_equal(Array, next_gen.class)
    assert_equal(next_gen.size, population.size)
  end

end

class TestTournamentSelector < Test::Unit::TestCase

  def test_initilization
    assert_nothing_raised(ArgumentError) { TournamentSelector.new }
    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_percentage => 0}) }
    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_percentage => 1}) }
    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_percentage => 0.5}) }
    assert_raise(ArgumentError) { TournamentSelector.new({:tournament_percentage =>  2}) }
    assert_raise(ArgumentError) { TournamentSelector.new({:tournament_percentage => -2}) }

    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_selection_probability => 0}) }
    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_selection_probability => 1}) }
    assert_nothing_raised(ArgumentError) { TournamentSelector.new({:tournament_selection_probability => 0.5}) }
    assert_raise(ArgumentError) { TournamentSelector.new({:tournament_selection_probability =>  2}) }
    assert_raise(ArgumentError) { TournamentSelector.new({:tournament_selection_probability => -2}) }
  end
  
  def test_select_next_generation
    selector = RouletteSelector.new
    chromosome = mock()
    chromosome.stubs(:fitness).returns(1)
    population = Array.new(5)
    population.fill(chromosome)
    next_gen = selector.select_next_generation(population)
    assert_equal(Array, next_gen.class)
    assert_equal(next_gen.size, population.size)
  end

  def select_candidate
    
  end

end