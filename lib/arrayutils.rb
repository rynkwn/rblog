module Arrayutils
  
  # @param array is an array you want to select from.
  # @param indices is an array of numeric indices that you wish to select from
  # array.
  def Arrayutils.values_at(array, indices)
    temp = []
    
    indices.each do |index|
      temp << array[index]
    end
    
    return temp
  end
  
  # Figure out if a body of text contains at least one element of a String array
  # efficiently
  # @param bodytext
  # @param array is the String array which we're comparing on bodytext.
  def Arrayutils.contains_string(bodytext, array)
    array.each do |word|
      if(bodytext.include? word)
        return true
      end
    end
    
    return false
  end
end