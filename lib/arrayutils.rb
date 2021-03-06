module Arrayutils
  
  #############################################################
  #
  # General Array Manipulation
  #
  #############################################################
  
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
  
  # Returns an array sans values at specified indices.
  def Arrayutils.delete_at(array, indices)
    temp = []
    
    for i in 0..(array.length - 1)
      if(! indices.include? i)
        temp << array[i]
      end
    end
    
    return temp
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
  
  # Create a hash grouping elements defined by some delimiting identity.
  # Array must be well-structured. Category precedes elements it defines.
  # @param array The original array
  # @param categorize Some proc which identifies an element as a category or otherwise.
  # @param downcase_keys A boolean option to determine whether keys are downcased
  # @param strip_keys A boolean option for whether or not to strip keys.
  def Arrayutils.group(array, categorize, downcase_keys, strip_keys)
    grouped = Hash.new() { |h,k| h[k] = Array.new }  # Set default value as an empty list
    category = ""
  
    for i in 0..(array.size - 1)
      if categorize.call(array[i])
        category = array[i]
        category = downcase_keys ? category.downcase : category
        category = strip_keys ? category.strip : category
      else
        grouped[category] = grouped[category] << array[i]
      end
    end
    
    return grouped
  end
  
  # A modified version of uniq. Returns an array of indices that reflect
  # redundant values in the array. If the array is ["1", "2", "3", "2"], then the function
  # will return [3], which is the index of the second "2"
  # @param array Is the array we'll be analyzing
  # @param similarity Is the minimum similarity of two items for them to be
  # considered "equal".
  def Arrayutils.redundant_indices(array)
    map = {}
    indices = []
    
    for i in 0..(array.length - 1)
      if(map[array[i]].nil?)
        map[array[i]] = true
      else
        indices << i
      end
    end
    
    return indices
  end
  
  # Replaces instances of X with Y in the array.
  def Arrayutils.replace(array, x, y)
    array = array.map{|val| val == x ? y : val}
  end
  
  #############################################################
  #
  # Arrays and Hashes
  #
  #############################################################
  
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
end