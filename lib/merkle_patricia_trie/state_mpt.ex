defmodule StateMPT do
  alias MerklePatriciaTree.Trie
  alias StateDb

  def get_account(address, block_hash) do
    bin_block_hash = Util.format_key(block_hash)
    addr_hash = :keccakf1600.hash(:sha3_256, Util.format_key(address))

    StateDb.init()
    |> Trie.new(bin_block_hash)
    |> Trie.get(addr_hash)
    |> Account.from_rlp()
  end
end
