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

  @doc """
  Insert a branch in a general tree.

  The branch should be provided as a list of values. The head of the list will be
  used as the root of the branch.
  The branch is inserted as a tree under the provided tree. The reason is because when
  the root of the branch doesn't match the root of the provided tree, a forest must be
  created under a new root which may not be desirable.
  """
  @spec insert_branch(t, [any]) :: t
  def insert_branch(nil, nil) do
    nil
  end

  def insert_branch(nil, [value | rest]) do
    insert_branch(%GeneralTree{value: value}, rest)
  end

  def insert_branch(tree, nil) do
    tree
  end

  def insert_branch(tree, []) do
    tree
  end

  def insert_branch(tree, [value | rest] = branch) do
    index = Enum.find_index(tree.children, &(&1.value == value))
    subtree = case index do
                nil -> %GeneralTree{value: value}
                _ -> Enum.at tree.children, index
              end
    subforest = case index do
                  nil -> tree.children ++ [insert_branch(subtree, rest)]
                  _ -> List.replace_at(tree.children, index, insert_branch(subtree, rest))
                end
    %GeneralTree{tree | children: subforest}
  end
end
