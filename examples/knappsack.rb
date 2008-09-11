$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'
require 'chromosome_factory'
require 'java'

class KnappsackFactory < ChromosomeFactory

  attr_reader :size, :items

  def initialize(size, items)
    @size = size
    @items = items
  end
  
  def get_chromosome
    return Knappsack.new(self)
  end

end

class Knappsack < ListChromosome

  attr_reader :fitness, :genes, :factory
  
  def initialize(factory, genes = [])
    super(genes)
    @factory = factory
    @space = @factory.size
  end

  def random_init
    factory.items.each do |item|
      if (rand(2)==0 and item.size <= self.space)
        @genes << true
      else
        @genes << false
      end
    end
  end

  def init_gene_at(index)
    if (rand(2)==0 and @factory.items[index].size <= self.space)
      return true
    else
      return false
    end
  end

  def size
    size = 0
    @factory.items.each_with_index do |item, index|
      size +=  item.size if @genes[index]
    end
    return size
  end
  
  def space
    @factory.size - self.size()
  end
  
  def compute_fitness
    if space < 0
      @fitness = factory.size * 2
    else
      @fitness = space
    end
   return @fitness
 end

end

class Item
  attr_reader :size
  
  def initialize(size)
    @size = size
  end
  
end
