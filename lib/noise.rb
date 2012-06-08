class Noise
  

 Noise_words = ["about", "after", "all", "also", "an", "and", "another", "any", "are", "as", "at", "be", "because", "been", "before
being", "between", "both", "but", "by", "came", "can", "come", "could", "did", "do", "each", "for", "from", "get
got", "has", "had", "he", "have", "her", "here", "him", "himself", "his", "how", "if", "in", "into", "is", "it", "like
make", "many", "me", "might", "more", "most", "much", "must", "my", "never", "now", "of", "on", "only", "or", "other
our", "out", "over", "said", "same", "see", "should", "since", "some", "still", "such", "take", "than", "that
the", "their", "them", "then", "there", "these", "they", "this", "those", "through", "to", "too", "under", "up
very", "was", "way", "we", "well", "were", "what", "where", "which", "while", "who", "with", "would", "you", "your", 
"a", "no", "b.d.", "birth", "day", 'b'
]

  def self.make_quiet(words)
    removed_noise = words.select {|w| is_not_noise?(w)}
    return removed_noise
  end
  
  def self.is_not_noise?(word)
    return false if Noise_words.include?(word.downcase)
    return false if word =~ /\?+/
    return true
  end
  
end