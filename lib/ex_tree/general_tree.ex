defmodule ExTree.GeneralTree do
  alias ExTree.GeneralTree

  @type t :: %GeneralTree{value: any, children: list}
  defstruct value: nil, children: []

  @doc """
  Indicates if a tree is a leaf.

  A tree is a leaf if its children property is an empty list
  .
  """
  @spec leaf?(t) :: boolean
  def leaf?(tree) do
    case tree do
      %GeneralTree{children: []} -> true
      _ -> false
    end
  end

  @doc """
  Depth first traversal of a tree.

  Invokes tree_visitor on each tree and accumulates the results in a list.
  """
  @spec depth_first_traversal(t, (t -> any)) :: list
  def depth_first_traversal(tree, tree_visitor \\ fn tree -> tree.value end) do
    depth_first_traversal_acc([tree_visitor.(tree)], tree.children, tree_visitor)
    |> Enum.reverse
  end

  defp depth_first_traversal_acc(acc, forest, tree_visitor) do
    if forest == [] do
      acc
    else
      [tree | trees] = forest
      depth_first_traversal_acc([tree_visitor.(tree) | acc], tree.children ++ trees, tree_visitor)
    end
  end

  @doc """
  Breadth first traversal of a tree.

  Invokes tree_visitor on each tree and accumulates the results in a list.
  """
  @spec breadth_first_traversal(t, (t -> any)) :: list
  def breadth_first_traversal(tree, tree_visitor \\ fn tree -> tree.value end) do
    breadth_first_traversal_acc([tree_visitor.(tree)], tree.children, tree_visitor)
    |> Enum.reverse
  end

  defp breadth_first_traversal_acc(acc, forest, tree_visitor) do
    if forest == [] do
      acc
    else
      [tree | trees] = forest
      breadth_first_traversal_acc([tree_visitor.(tree) | acc], trees ++ tree.children, tree_visitor)
    end
  end
end
