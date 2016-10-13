class InvalidCodonError < StandardError; end
# translates condon string to proteins
class Translation
  CODONS = { %w(AUG) => 'Methionine',
             %w(UUU UUC) => 'Phenylalanine',
             %w(UUA UUG) => 'Leucine',
             %w(UCU UCC UCA UCG) => 'Serine',
             %w(UAU UAC) => 'Tyrosine',
             %w(UGU UGC) => 'Cysteine',
             %w(UGG) => 'Tryptophan',
             %w(UAA UAG UGA) => 'STOP' }.freeze

  def self.of_codon(codon_string)
    raise InvalidCodonError if codon_string =~ /[^AUCG]/
    CODONS.detect { |key, _| key.include?(codon_string) }.last
  end

  def self.of_rna(strand)
    strand.scan(/.{3}/).each_with_object([]) do |codon_string, answer|
      codon = of_codon(codon_string)
      return answer if codon == 'STOP'
      answer << codon
    end
  end
end
