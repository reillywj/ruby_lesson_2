class Hamming
  DIFFERENTIATING_CHAR = '^'.freeze
  def self.compute(string1, string2)
    diff_string = ''
    #Return nil if different lengths
    #Return count of number of differences
    smallest_string = ''
    shortest_string = string1 if string1.length < string2.length
    shortest_string = string2 if string2.length <= string1.length
    unless string1.empty? || string2.empty?
      shortest_string.length.times do |i|
        diff_string = diff_string + ' ' if string1[i] == string2[i]
        diff_string = diff_string + DIFFERENTIATING_CHAR if string1[i] != string2[i]
      end
      puts string1
      puts string2
      puts diff_string
      hamming_distance = diff_string.split.join.length
      puts "Hamming Distance: #{hamming_distance}"
      hamming_distance
    else
      return nil
    end#if
  end#def
end#class