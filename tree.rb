require_relative 'node'

class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return if array.empty?

    sorted_array = array.sort.uniq
    return Node.new(sorted_array[0]) if sorted_array.length <= 1

    mid = sorted_array.length / 2
    root = Node.new(sorted_array[mid])
    root.left = build_tree(sorted_array[0...mid])
    root.right = build_tree(sorted_array[mid + 1..-1])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
  def insert(value, node = @root)
    # just insert left or right depending on number
    return if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end
end

list = Tree.new([1,2,3,4,5,6,7,8,9])
list.insert(10)
list.pretty_print