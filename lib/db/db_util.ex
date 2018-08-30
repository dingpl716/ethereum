defmodule DbUtil do
  alias Rox

  @db_path "/var/data/parity/chains/ethereum/db/906a34e69aec8c0d/archive/db"
  @column_families ["col7", "col6", "col1", "col0", "col2", "col3", "col4", "col5"]
  @opts [max_open_files: 0]

  def open_db do
    {:ok, db, cfs} = Rox.open(@db_path, @opts, @column_families)
    {db, cfs}
  end

  def get_state(key, cfs) do
    case Rox.get(cfs["col0"], key) do
      {:ok, value} -> value
      :not_found -> :not_found
    end
  end

  def get_header(key, cfs) do
    {:ok, value} = Rox.get(cfs["col1"], key)

    [
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
    ] = ExRLP.decode(value)

    %{
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
