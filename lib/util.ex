defmodule Util do
  def format_key(key) do
    case String.valid?(key) do
      true -> Base.decode16!(key, case: :lower)
      false -> key
    end
  end
end
