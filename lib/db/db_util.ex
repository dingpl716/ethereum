defmodule DbUtil do
  alias Rox

  @db_path "/var/data/parity/chains/ethereum/db/906a34e69aec8c0d/archive/db"
  def open_db do
    Rox.open(@db_path)
  end
end
