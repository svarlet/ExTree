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
    IO.puts "Inserting #{inspect branch} into #{inspect tree}"
    index = Enum.find_index(tree.children, &(&1.value == value))
    subtree = case index do
                nil -> %GeneralTree{value: value}
                _ -> tree.children[index]
              end
    subforest = case index do
                  nil -> tree.children ++ [insert_branch(subtree, rest)]
                  _ -> List.replace_at(tree.children, index, insert_branch(subtree, rest))
                end
    tt = %GeneralTree{tree | children: subforest}
    IO.puts "Created/Returning new tree: #{inspect tt}"
    tt
  end
end
