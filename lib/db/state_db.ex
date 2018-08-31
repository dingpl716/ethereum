defmodule StateDb do
  alias MerklePatriciaTree.DB
  alias MerklePatriciaTree.Trie

  @behaviour MerklePatriciaTree.DB

  @spec init(DB.db_name()) :: DB.db()
  def init(_) do
    {__MODULE__, nil}
  end

  @doc """
  Retrieves a key from the database.
  """
  @spec get(DB.db_ref(), Trie.key()) :: {:ok, DB.value()} | :not_found
  def get(_, key) do
    DbUtil.get_state(key)
  end

  @doc """
  Stores a key in the database.
  """
  @spec put!(DB.db_ref(), Trie.key(), DB.value()) :: :ok
  def put!(_db_ref, _key, _value) do
    raise("Not implemented")
  end
end
