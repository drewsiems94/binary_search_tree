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

      queue << queue.first.left unless node.left.nil?
      queue << queue.first.right unless node.right.nil?
      queue.shift
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
    until stack.empty?
      if block_given?
        yield stack[-1]
      else
        arr << stack[-1].data
      end
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
end

list = Tree.new([1,2,3,4,5,6,7])
list.insert(10)
list.pretty_print
puts list.height(4)


# Try level order recursion
