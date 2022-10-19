require_relative 'node'
require 'pry-byebug'

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
    return if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
      return node # return the node to make sure the left node remains unchanged
    elsif value > node.data
      node.right = delete(value, node.right)
      return node
    end

    if node.right.nil?
      node = node.left
    elsif node.left.nil?
      node = node.right
    else
      parent = node
      child = node.right
      until child.left.nil?
        parent = child
        child = parent.left
      end
      if parent.data != node.data
        parent.left = child.right
      else
        node.right = child.right
      end
      node.data = child.data
      child = nil
    end
    node # return the value of the node in the method call
  end

  def find(value, node = @root)
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root)
    return if node.nil?

    array = []
    queue = [node]
    until queue.compact.empty?
      if block_given?
        yield queue.first
      else
        array << queue.first.data
      end
      node = queue.first
      queue.shift
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
    array
  end

  # The method needs the block each time you call it (recursion)
  def inorder(node = @root, arr = [], &block)
    return if node.nil?

    inorder(node.left, arr, &block)
    if block_given?
      block.call(node)
    else
      arr << node.data
    end
    inorder(node.right, arr, &block)
    arr
  end

  def preorder(node = @root)
    return if node.nil?

    arr = []
    stack = [node]
    until stack.compact.empty?
      if block_given?
        yield stack[-1]
      else
        arr << stack[-1].data
      end
      node = stack[-1]
      stack.pop
      stack << node.right unless node.right.nil?
      stack << node.left unless node.left.nil?
    end
    arr
  end

  def postorder(node = @root, arr = [], &block)
    # left, right, node
    return if node.nil?

    postorder(node.left, arr, &block)
    postorder(node.right, arr, &block)
    if block_given?
      block.call(node)
    else
      arr << node.data
    end
    arr
  end

  def height(value, node = self.find(value))
    return -1 if node.nil?

    left_height = height(value, node.left)
    right_height = height(value, node.right)
    left_height >= right_height ? left_height + 1 : right_height + 1
  end

  def depth(value)
    node = @root
    depth = 0
    return 0 if value == node.data

    until node.data == value
      if value < node.data
        depth += 1
        node = node.left
      else
        depth += 1
        node = node.right
      end
    end
    depth
  end

  def balanced?
    (height(@root.left.data) - height(@root.right.data)).abs > 1 ? false : true
  end

  def rebalance
    return if self.balanced?

    arr = self.inorder
    @root = build_tree(arr)
  end
end

# Driver code

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts tree.balanced?
print tree.level_order
print tree.inorder
print tree.preorder
print tree.postorder
tree.insert(101)
tree.insert(189)
tree.insert(164)
tree.insert(194)
tree.insert(103)
tree.insert(199)
tree.pretty_print
puts tree.balanced?
tree.rebalance
puts tree.balanced?
tree.pretty_print
print tree.level_order
print tree.inorder
print tree.preorder
print tree.postorder

# Try level order recursion
