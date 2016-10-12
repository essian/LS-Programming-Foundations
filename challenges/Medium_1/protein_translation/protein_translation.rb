class InvalidCodonError < StandardError; end

class Translation
  CODONS = { ['AUG'] => 'Methionine',
             ['UUU', 'UUC'] => 'Phenylalanine',
             ['UUA', 'UUG'] => 'Leucine',
             ['UCU', 'UCC', 'UCA', 'UCG'] => 'Serine',
             ['UAU', 'UAC'] => 'Tyrosine',
             ['UGU', 'UGC'] => 'Cysteine',
             ['UGG'] => 'Tryptophan',
             ['UAA', 'UAG', 'UGA'] => 'STOP' }.freeze

  def self.of_codon(codon_string)
    CODONS.select { |key, _| key.include?(codon_string) }.values.first
  end

  def self.of_rna(strand)
    raise InvalidCodonError if strand =~ /[^AUCG]/
    strand.scan(/.{3}/).each_with_object([]) do |codon_string, answer|
      codon = of_codon(codon_string)
      return answer if codon == 'STOP'
      answer << codon
    end
  end
end
