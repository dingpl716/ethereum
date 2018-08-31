defmodule BlockHeader do
  defstruct [
    :pre_hash,
    :uncle,
    :miner,
    :state_root,
    :transactions_root,
    :receipts_root,
    :logs_bloom,
    :difficulty,
    :height,
    :gas_limit,
    :gas_used,
    :time,
    :extra_data,
    :mix_hash,
    :nonce
  ]

  def from_rlp(rlp_value) do
    from_binary(ExRLP.decode(rlp_value))
  end

  def from_binary([
        pre_hash,
        uncle,
        miner,
        state_root,
        transactions_root,
        receipts_root,
        logs_bloom,
        difficulty,
        height,
        gas_limit,
        gas_used,
        time,
        extra_data,
        mix_hash,
        nonce
      ]) do
    %BlockHeader{
      pre_hash: Base.encode16(pre_hash, case: :lower),
      uncle: Base.encode16(uncle, case: :lower),
      miner: Base.encode16(miner, case: :lower),
      state_root: Base.encode16(state_root, case: :lower),
      transactions_root: Base.encode16(transactions_root, case: :lower),
      receipts_root: Base.encode16(receipts_root, case: :lower),
      logs_bloom: logs_bloom,
      difficulty: Base.encode16(difficulty, case: :lower),
      height: :binary.decode_unsigned(height),
      gas_limit: :binary.decode_unsigned(gas_limit),
      gas_used: :binary.decode_unsigned(gas_used),
      time: :binary.decode_unsigned(time) |> DateTime.from_unix(),
      extra_data: extra_data,
      mix_hash: Base.encode16(mix_hash, case: :lower),
      nonce: Base.encode16(nonce, case: :lower)
    }
  end
end
