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

  test "depth first traversal" do
    #     1
    #    / \
    #   2   3
    #  / \
    # 4   5
    subtree4 = %GeneralTree{value: 4}
    subtree5 = %GeneralTree{value: 5}
    subtree2 = %GeneralTree{value: 2, children: [subtree4, subtree5]}
    subtree3 = %GeneralTree{value: 3}
    subtree1 = %GeneralTree{value: 1, children: [subtree2, subtree3]}

    value_extractor = fn node -> node.value end

    assert depth_first_traversal(subtree4, value_extractor) == [4]
    assert depth_first_traversal(subtree2, value_extractor) == [2, 4, 5]
    assert depth_first_traversal(subtree1, value_extractor) == [1, 2, 4, 5, 3]
  end

end
