defmodule MPT do
  def get_first_child(root) do
    dfs(root, "")
  end

  defp dfs(key, prefix) when is_binary(key) and is_binary(prefix) do
    case DbUtil.get_state(key) do
      :not_found -> :not_found
      {:ok, rlp_value} -> rlp_value |> ExRLP.decode() |> process_node(prefix)
    end
  end

  defp process_node(items, prefix) when is_list(items) do
    case length(items) do
      17 -> process_branch(items, prefix)
      2 -> process_extension_leaf(items, prefix)
    end
  end

  defp process_branch(items, prefix) do
    {key, index} =
      items
      |> Enum.with_index()
      |> Enum.find(fn {key, _} -> key != "" end)

    prefix = prefix <> Integer.to_string(index, 16)
    dfs(key, prefix)
  end

  defp process_extension_leaf([encode_path, value], prefix) do
    path = Base.encode16(encode_path, case: :lower)

    case String.first(path) do
      "0" ->
        prefix = prefix <> String.slice(path, 2..String.length(path))
        dfs(value, prefix)

      "1" ->
        prefix = prefix <> String.slice(path, 1..String.length(path))
        dfs(value, prefix)

      "2" ->
        prefix = prefix <> String.slice(path, 2..String.length(path))
        [nonce, balance, storage_root, code_hash] = ExRLP.decode(value)
        to_state_object(prefix, nonce, balance, storage_root, code_hash)

      "3" ->
        prefix = prefix <> String.slice(path, 1..String.length(path))
        [nonce, balance, storage_root, code_hash] = ExRLP.decode(value)
        to_state_object(prefix, nonce, balance, storage_root, code_hash)
    end
  end

  defp to_state_object(prefix, nonce, balance, storage_root, code_hash) do
    %{
      address: prefix,
      nonce: :binary.decode_unsigned(nonce),
      balance: :binary.decode_unsigned(balance),
      storage_root: Base.encode16(storage_root, case: :lower),
      code_hash: Base.encode16(code_hash, case: :lower)
    }
  end
end
