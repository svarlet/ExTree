defmodule ExTree.GeneralTree do
  alias ExTree.GeneralTree

  @type t :: %GeneralTree{value: any, children: list}
  defstruct value: nil, children: []

  @doc """
  Indicates if a tree is a leaf.

  A tree is a leaf if its children property is an empty list
  .
  """
  def leaf?(tree) do
    case tree do
      %GeneralTree{children: []} -> true
      _ -> false
    end
  end

  @doc """
  Depth first traversal of a tree.

  Invokes node_visitor on each node/leaf and accumulates results in an
  accumulator.
  """
  @spec depth_first_traversal(t, (t -> any)) :: list
  def depth_first_traversal(tree, _node_visitor) do
    depth_first_traversal_acc([tree.value], tree.children)
    |> Enum.reverse
  end

  defp depth_first_traversal_acc(acc, forest) do
    if forest == [] do
      acc
    else
      [tree | trees] = forest
      depth_first_traversal_acc([tree.value | acc], tree.children ++ trees)
    end
  end
end
