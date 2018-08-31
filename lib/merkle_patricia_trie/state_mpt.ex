defmodule StateMPT do
  alias MerklePatriciaTree.Trie
  alias StateDb

  def get_account(address, state_root) do
    addr_hash = :keccakf1600.hash(:sha3_256, Util.format_key(address))
    search_trie(addr_hash, state_root)
  end

  def search_trie(key, root) do
    bin_root = Util.format_key(root)
    bin_key = Util.format_key(key)

    StateDb.init()
    |> Trie.new(bin_state_root)
    |> Trie.get(addr_hash)
    |> Account.from_rlp()
  end
end
