defmodule MPT do
  def get_first_child(root, cfs) do
    dfs(root, "", cfs)
  end

  defp dfs(key, prefix, cfs) when is_binary(key) and is_binary(prefix) do
    key
    |> DbUtil.get_state(cfs)
    |> dfs(prefix)
  end

  defp dfs(:not_found, cfs), do: :not_found

  defp dfs({:ok, node}, prefix, cfs), do: process_node(node, prefix, cfs)

  defp process_node(items, prefix, cfs) when is_list(items) do
    case length(items) do
      17 -> process_branch(items, prefix, cfs)
      2 -> process_extension_leaf(items, prefix, cfs)
    end
  end

  defp process_branch(items, prefix, cfs) do
    {key, index} =
      items
      |> Enum.with_index()
      |> Enum.find(fn {key, _} -> key != "" end)

    prefix = prefix <> Integer.to_string(index, 16)
    dfs(key, prefix, cfs)
  end

  defp process_extension_leaf([encode_path, value], prefix, cfs) do
    path = Base.encode16(encode_path, case: :lower)

    case String.first(path) do
      "0" ->
        prefix = prefix <> String.slice(path, 2..String.length(path))
        dfs(value, prefix, cfs)

      "1" ->
        prefix = prefix <> String.slice(path, 1..String.length(path))
        dfs(value, prefix, cfs)

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
