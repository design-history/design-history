module ArrayElementMove
  MustBeUniqArray = Class.new(StandardError)
  ItemNotInArray = Class.new(StandardError)

  def self.up!(array, item)
    check_if_uniq!(array)
    return array if array.first == item
    position = array.index(item) || raise(ItemNotInArray)
    array.insert((position - 1), array.delete_at(position))
  end

  def self.down!(array, item)
    check_if_uniq!(array)
    return array if array.last == item
    position = array.index(item) || raise(ItemNotInArray)
    array.insert((position + 1), array.delete_at(position))
  end

  def self.check_if_uniq!(array)
    raise MustBeUniqArray if array.size != array.uniq.size
  end
end
