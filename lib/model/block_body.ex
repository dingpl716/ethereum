defmodule BlockBody do
  defstruct [:transactions, :uncles]

  def from_rlp(rlp_value) do
    [transactions, uncles] = ExRLP.decode(rlp_value)

    %BlockBody{
      transactions: Enum.map(transactions, &Transaction.from_binary/1),
      uncles: Enum.map(uncles, &BlockHeader.from_binary/1)
    }
  end
end
