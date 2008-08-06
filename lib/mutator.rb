class NilMutator
  
  def mutate(chromosome)
  end

end

class SingleMutator
  
  def mutate(chromosome)
    indices = [ rand(chromosome.size) ]
    return indices
  end
  
end

class ProbabilityMutator
  
  def initialize(probability)
    raise(ArgumentError, "Probabiltity must be between an Numeric between 0 and 1.") unless
      (0 <= probability and probability <= 1)
    @probability = probability
  end

  def mutate(chromosome)
    indices = []
    size = chromosome.size
    size.times do |index|
      indices << index if (rand <= @probability)
    end
    return indices
  end

end
