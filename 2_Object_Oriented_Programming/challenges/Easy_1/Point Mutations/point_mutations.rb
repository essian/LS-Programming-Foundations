class DNA
  def initialize(gene_str)
    @gene_str = gene_str
  end

  def hamming_distance(other_gene_str)
    count = 0
    @gene_str.chars.each_with_index do |char, index|
      return count if char == nil || other_gene_str[index] == nil
      count += 1 unless char == other_gene_str[index]
    end
    count

  end
end
