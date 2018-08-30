defmodule DbUtil do
  alias Rox
  use GenServer

  @db_util {:global, __MODULE__}
  @db_path "/var/data/parity/chains/ethereum/db/906a34e69aec8c0d/archive/db"
  @column_families ["col0", "col1", "col2", "col3", "col4", "col5", "col6", "col7"]
  @opts [max_open_files: 0]

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @db_util)
  end

  def get_header(key) do
    case byte_size(key) do
      32 -> GenServer.call(@db_util, {:get_header, key})
      64 -> GenServer.call(@db_util, {:get_header, Base.decode16!(key, case: :lower)})
    end
  end

  # call backs
  def init do
    {:ok, open_db()}
  end

  def open_db do
    {:ok, db, cfs} = Rox.open(@db_path, @opts, @column_families)

    col_families = %{
      state: cfs["col0"],
      block_header: cfs["col1"],
      block_body: cfs["col2"],
      extra: cfs["col3"],
      trace: cfs["col4"],
      empty_account_bloom: cfs["col5"],
      general_info: cfs["col6"],
      light_client: cfs["col7"]
    }

    {db, col_families}
  end

  def handle_call({:get_header, key}, _from, {_, %{block_header: cf}} = gen_server_state) do
    {:ok, rlp_value} = Rox.get(cf, key)
    header = BlockHeader.from_rlp(rlp_value)
    {:reply, header, gen_server_state}
  end

  def get_state(key, cfs) do
    case Rox.get(cfs["col0"], key) do
      {:ok, value} -> value
      :not_found -> :not_found
    end
  end

  def get_header(key, cfs) do
    {:ok, value} = Rox.get(cfs["col1"], key)
  end
end
