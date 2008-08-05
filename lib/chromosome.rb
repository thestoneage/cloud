class ListChromosome

  attr_reader :genes

  def initialize(genes=[])
    @genes = genes
  end

  def crossover(partner)
    raise(ArgumentError, "Size of Genes differs") unless (@genes.size == partner.genes.size)
    child_genes = Array.new(genes.size)
    child_genes.each_index do |index|
      if (rand(2) == 0)
        child_genes[index] = @genes[index]
      else
        child_genes[index] = partner.genes[index]
      end
    end
    return self.class.new(child_genes)
  end

  def size
    return @genes.size
  end

  def mutate(mutator)
    mutator.mutate(self)
    return self
  end

  def mutate_gene_at(index)
    raise(NotImplementedError)
  end
  
  def random_init
    raise(NotImplementedError)
  end
  
  def compute_fitness
    return @fitness
  end

end