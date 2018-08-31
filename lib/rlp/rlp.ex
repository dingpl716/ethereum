defmodule Ethereum.RLP do
  require Integer

  # At most use 8 bytes to represent the length
  @max_length :math.pow(256, 8)

  #################### Encoding #####################

  def encode(<<input>>) when input in 0x00..0x7F, do: <<input>>

  def encode(input) when is_number(input) do
    input |> to_binary() |> encode()
  end

  def encode(input) when is_binary(input) do
    encode_length(byte_size(input), 0x80) <> input
  end

  def encode(input) when is_list(input) do
    output = Enum.reduce(input, <<>>, fn item, acc -> acc <> encode(item) end)
    encode_length(byte_size(output), 0xC0) <> output
  end

  def encode_length(length, offset) do
    cond do
      length <= 55 ->
        <<length + offset>>

      length < @max_length ->
        binary_length = to_binary(length)
        <<byte_size(binary_length) + offset + 55>> <> binary_length

      true ->
        raise("Input too long")
    end
  end

  def to_binary(0), do: ""

  def to_binary(number) when is_number(number) and number > 0 do
    :binary.encode_unsigned(number)
  end

  #################### Decoding #####################
  def decode(<<>>), do: 0

  def decode_item(<<prefix::bytes-size(1), rest::bytes>>, result) when prefix <= 0x7F do
    item = <<prefix>>
    result = add_new_item(result, item)
    decode_item(rest, result)
  end

  def decode_item(<<prefix::bytes-size(1), _rest::bytes>>, _result) when prefix <= 0xB7 do
    nil
  end

  def decode_item() do
    nil
  end

  def add_new_item(nil, item), do: item
  def add_new_item(result, item), do: result ++ [item]
end
