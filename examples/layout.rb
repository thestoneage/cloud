$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'chromosome'

class LayoutChromosome < ListChromosome
  
  attr_reader :fitness
  
  def initialize
    @domain = []
    50.times { @domain << [25, 10] }
  end
  
  def compute_fitness
    @fitnes = nil
  end
  
end