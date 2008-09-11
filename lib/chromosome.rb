class ListChromosome

  attr_reader :genes, :fitness
  attr_writer :genes

  def initialize(genes=[])
    @genes = genes
  end

  def <=> other
    return self.fitness<=>other.fitness
  end

  def crossover(partner)
    raise(ArgumentError, "Size of Genes differs") unless (@genes.size == partner.genes.size)
    child_genes = Array.new(@genes.size)
    child_genes.each_index do |index|
      if (rand(2) == 0)
        child_genes[index] = @genes[index]
      else
        child_genes[index] = partner.genes[index]
      end
    end
    child = self.clone
    child.genes = child_genes
    return child
  end

  def mutate(mutator)
    mutated_genes = @genes.clone
    indices = mutator.mutate(self)
    indices.each { |index| mutated_genes[index] = init_gene_at(index) }
    mutation = self.clone
    mutation.genes = mutated_genes
    return mutation
  end

  def random_init
    raise(NotImplementedError)
  end

  def init_gene_at(index)
    raise(NotImplementedError)
  end

  def compute_fitness
    raise(NotImplementedError)
  end

end