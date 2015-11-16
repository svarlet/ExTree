defmodule ExTree.GeneralTree do
  alias ExTree.GeneralTree

  @type t :: %GeneralTree{value: any, children: list}
  defstruct value: nil, children: []

  @doc """
  Indicates if a tree is a leaf.

  A tree is a leaf if its children property is an empty list.
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

  def insert_branch(tree, branch) do
    cond do
      tree == nil -> branch
      branch == nil -> tree
      true ->
        path = build_insertion_path([], tree, branch)
        # rebuild the tree by consuming the path
    end
  end

  defp build_insertion_path(path, tree, branch) do
    case Enum.find_index(tree.children, &(&1.value == branch.value)) do
      nil -> [{length(tree.children), tree} | path]
      index -> build_insertion_path([{index, tree} | path], tree, branch.children[0])
    end
  end
end
