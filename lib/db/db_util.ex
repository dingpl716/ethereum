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

  def get_db do
    GenServer.call(@db_util, :get_db)
  end

  @spec get_state(binary()) :: {:ok, binary()} | :not_found
  def get_state(key) do
    GenServer.call(@db_util, {:get_state, key})
  end

  @spec get_header(binary()) :: %BlockHeader{} | :not_found
  def get_header(key) do
    GenServer.call(@db_util, {:get_header, key})
  end

  def get_body(key) do
    GenServer.call(@db_util, {:get_body, key})
  end

  # call backs
  def init(_) do
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

  def handle_call(:get_db, _from, gen_server_state) do
    {:reply, gen_server_state, gen_server_state}
  end

  @doc """
  Get block header by block hash
  """
  def handle_call({:get_header, key}, _from, {_, %{block_header: cf}} = gen_server_state) do
    header =
      case get_value(cf, key) do
        :not_found -> :not_found
        {:ok, rlp_value} -> BlockHeader.from_rlp(rlp_value)
      end

    {:reply, header, gen_server_state}
  end

  @doc """
  Get block body by block hash
  """
  def handle_call({:get_body, key}, _from, {_, %{block_body: cf}} = gen_server_state) do
    body =
      case get_value(cf, key) do
        :not_found -> :not_found
        {:ok, rlp_value} -> BlockBody.from_rlp(rlp_value)
      end

    {:reply, body, gen_server_state}
  end

  def handle_call({:get_state, key}, _from, {_, %{state: cf}} = gen_server_state) do
    state = get_value(cf, key)
    {:reply, state, gen_server_state}
  end

  def get_value(cf, key) do
    bin_key = Util.format_key(key)
    Rox.get(cf, bin_key)
  end

  def try_get(cfs, key) do
    cfs
    |> Map.values()
    |> Enum.map(fn cf -> get_value(cf, key) end)
  end
end
