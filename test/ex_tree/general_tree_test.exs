defmodule ExTree.GeneralTreeTest do
  use ExUnit.Case

  alias ExTree.GeneralTree
  import ExTree.GeneralTree

  test "has a nil value by default" do
    tree = %GeneralTree{}
    assert nil == tree.value
  end

  test "has no children by default" do
    tree = %GeneralTree{}
    assert [] == tree.children
  end

  test "a tree with no children is a leaf" do
    assert leaf?(%GeneralTree{value: "root"})
    assert leaf?(%GeneralTree{value: "root", children: []})
  end

  test "a tree with children is not a leaf" do
    subtree = %GeneralTree{value: "subtree"}
    tree = %GeneralTree{value: "root", children: [subtree]}
    assert leaf?(tree) == false
  end

  defmacro create_sample do
    #     1
    #    / \
    #   2   3
    #  / \
    # 4   5
    subtree4 = Macro.var :subtree4, nil
    subtree5 = Macro.var :subtree5, nil
    subtree2 = Macro.var :subtree2, nil
    subtree3 = Macro.var :subtree3, nil
    subtree1 = Macro.var :subtree1, nil
    quote do
      unquote(subtree4) = %GeneralTree{value: 4}
      unquote(subtree5) = %GeneralTree{value: 5}
      unquote(subtree2) = %GeneralTree{value: 2, children: [unquote(subtree4), unquote(subtree5)]}
      unquote(subtree3) = %GeneralTree{value: 3}
      unquote(subtree1) = %GeneralTree{value: 1, children: [unquote(subtree2), unquote(subtree3)]}
    end
  end

  test "depth first traversal constructs a list with the visitor function" do
    create_sample
    enqueue = fn value, queue -> queue ++ [18 * value] end
    assert depth_first_traversal(subtree4, [], enqueue) == [4 * 18]
    assert depth_first_traversal(subtree2, [], enqueue) == [2 * 18, 4 * 18, 5 * 18]
    assert depth_first_traversal(subtree1, [], enqueue) == [1 * 18, 2 * 18, 4 * 18, 5 * 18, 3 * 18]
  end

  test "breadth first traversal constructs a list of the tree values" do
    create_sample
    assert breadth_first_traversal(subtree4) == [4]
    assert breadth_first_traversal(subtree2) == [2, 4, 5]
    assert breadth_first_traversal(subtree1) == [1, 2, 3, 4, 5]
  end

  test "breadth first traversal constructs a list with the visitor function" do
    create_sample
    times17 = fn tree -> tree.value * 17 end
    assert breadth_first_traversal(subtree4, times17) == [4 * 17]
    assert breadth_first_traversal(subtree2, times17) == [2 * 17, 4 * 17, 5 * 17]
    assert breadth_first_traversal(subtree1, times17) == [1 * 17, 2 * 17, 3 * 17, 4 * 17, 5 * 17]
  end

  test "inserting a nil branch into a tree returns the tree" do
    create_sample
    assert insert_branch(subtree1, nil) == subtree1
  end

  test "inserting an empty branch into a tree returns the tree" do
    create_sample
    assert insert_branch(subtree1, []) == subtree1
  end

  test "inserting a single element branch in a nil tree should return a leaf set with that element" do
    tree = insert_branch(nil, [42])
    assert tree.value == 42
    assert leaf?(tree)
  end

  test "inserting a branch into a nil tree returns a tree constructed from the branch element" do
    tree = insert_branch(nil, [1, 2, 3])
    t1 = tree
    t2 = Enum.at t1.children, 0
    t3 = Enum.at t2.children, 0
    assert [1, 2, 3] = [t1.value, t2.value, t3.value]
  end

  test "inserting a branch to a leaf sets this branch as its unique child" do
    leaf = %GeneralTree{value: 42}
    branch = ["a", "b"]
    tree = insert_branch(leaf, branch)
    assert tree.value == leaf.value
    assert %GeneralTree{value: 42, children: [%GeneralTree{value: "a", children: [%GeneralTree{value: "b"}]}]} = tree
  end

  test "inserting a branch in a tree which already contains part of this branch will insert the absent part of the branch" do
    tree = insert_branch(nil, [:a, :b, :c])
    tree_with_d_symbol = insert_branch(tree, [:b, :c, :d])
    assert tree_with_d_symbol.value == :a

    descendant = hd(tree_with_d_symbol.children)
    assert descendant.value == :b

    descendant = hd(descendant.children)
    assert descendant.value == :c

    descendant = hd(descendant.children)
    assert descendant.value == :d
  end

  test "inserting an already existing branch should return the original tree" do
    tree = insert_branch(nil, [:a, :b, :c])
    |> insert_branch([:b, :d])

    new_tree = insert_branch(tree, [:b, :d])
    assert tree == new_tree
  end

  test "inserting a branch into a multi branch tree should insert the missing nodes and leaf" do
    #      a
    #     / \
    #    b   e
    #   / \  /\
    #  c  d f  g

    tree = insert_branch(nil, [:a, :b, :c])
    |> insert_branch([:b, :d])
    |> insert_branch([:e, :f])
    |> insert_branch([:e, :g])

    assert tree.value == :a
    flunk "Structure of the tree should be verified."
  end

end
