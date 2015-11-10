defmodule ExTree.GeneralTree do
  alias ExTree.GeneralTree

  @type t :: %GeneralTree{value: any, children: list}
  defstruct value: nil, children: nil

  @doc """
  Indicates if a tree is a leaf.

  A tree is a leaf if it has no children (nil or []).
  """
  def leaf?(tree) do
    case tree do
      %GeneralTree{children: nil} -> true
      %GeneralTree{children: []} -> true
      _ -> false
    end
  end

  @doc """
  Depth first traversal of a tree.

  Invokes node_visitor on each node/leaf and accumulates results in an
  accumulator.
  """
  @spec depth_first_traversal(t, any, (t -> any)) :: list
  def depth_first_traversal(tree, acc \\ [], node_visitor) do
    if leaf?(tree) do
      acc ++ [node_visitor.(tree)]
    else
      List.foldl(tree.children, acc ++ [node_visitor.(tree)], fn node, acc -> depth_first_traversal(node, acc, node_visitor) end)
    end
  end
end
