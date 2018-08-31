defmodule Account do
  defstruct [:nonce, :balance, :storage_root, :code_hash]

  def from_rlp(rlp_value) do
    [nonce, balance, storage_root, code_hash] = ExRLP.decode(rlp_value)

    %Account{
      nonce: :binary.decode_unsigned(nonce),
      balance: :binary.decode_unsigned(balance),
      storage_root: Base.encode16(storage_root, case: :lower),
      code_hash: Base.encode16(code_hash, case: :lower)
    }
  end
end
