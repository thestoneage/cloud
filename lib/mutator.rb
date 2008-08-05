class NilMutator
  
  def mutate(chromosome)
  end

end

class SingleMutator
  
  def mutate(chromosome)
    chromosome.mutate_gene_at(rand(chromosome.size))
  end
  
end

class ProbabilityMutator
  
  def initialize(probability)
    raise(ArgumentError, "Probabiltity must be between an Numeric between 0 and 1.") unless
      (0 <= probability and probability <= 1)
    @probability = probability
  end

  def mutate(chromosome)
    chromosome.size.times do |index|
      chromosome.mutate_gene_at(index) if (rand() <= @probability)
    end
  end

end
