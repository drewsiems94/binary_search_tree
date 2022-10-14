
class Node
  attr_accessor :data, :right, :left

  def initialize(data = nil)
    @data = data
    @right = nil
    @left = nil
  end
end