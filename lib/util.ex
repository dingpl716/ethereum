defmodule Util do
  def format_key(key) do
    case String.valid?(key) do
      true -> key |> String.downcase() |> Base.decode16!(case: :lower)
      false -> key
    end
  end
end
