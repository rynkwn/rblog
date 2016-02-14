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
  
  # Return all elements (as indices) of array one that contain any elements in array two.
  # I work under the assumption that both arrays contain Strings. Unsure about
  # broader circumstances.
  # @param arrayOne is the array we're filtering with our array of conditions.
  # @param arrayTwo is our array of conditions.
  # @return An array of indices representing elements in arrayOne that satisfy
  # the conditions array.
  def Arrayutils.string_overlaps(arrayOne, arrayTwo)
    indices = []
    
    for i in 0..(arrayOne.length - 1)
      if Arrayutils::contains_string(arrayOne[i], arrayTwo)
        indices << i
      end
    end
    
    return indices
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
  
  # You pass in a hash and an array containing some concat-ed values.
  # @param hash is the hash that generated the concat-ed values.
  # @param hash_values is the array of values we're going to retrieve unique keys from.
  # @return All unique hash keys defined by the hash_values in an array.
  def Arrayutils.get_keys(hash, hash_values)
    keys = []
    hash.each do |k, v|
      v = v.split(",")
      if (hash_values.length > (hash_values - v).length)
        keys << k
      end
    end
    
    return keys
  end
  
  # Returns whether or not val exists in the array.
  def Arrayutils.include?(array, val)
    array.each do |x|
      if val == x
        return true
      end
    end
    return false
  end
end