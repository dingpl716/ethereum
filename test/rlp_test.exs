defmodule EthereumTest.RLP do
  use ExUnit.Case
  alias Ethereum.RLP

  test "dog" do
    assert RLP.encode("dog") == <<131, 100, 111, 103>>
  end

  test "cat, dog" do
    assert RLP.encode(["cat", "dog"]) == <<200, 131, 99, 97, 116, 131, 100, 111, 103>>
  end

  test "Empty string" do
    assert RLP.encode("") == <<0x80>>
  end

  test "Integer 0" do
    assert RLP.encode(0) == <<0x80>>
  end

  test "Integer 1024" do
    assert RLP.encode(1024) == <<0x82, 0x04, 0x00>>
  end

  test "Empty list" do
    assert RLP.encode([]) == <<0xC0>>
  end

  test "Encoded integer 0" do
    assert RLP.encode(<<0x00>>) == <<0x00>>
  end

  test "Encoded integer 15" do
    assert RLP.encode(<<0x0F>>) == <<0x0F>>
  end

  test "Encoded integer 1024" do
    assert RLP.encode(<<0x04, 0x00>>) == <<0x82, 0x04, 0x00>>
  end

  test "Nested list" do
    assert RLP.encode([[], [[]], [[], [[]]]]) ==
             <<0xC7, 0xC0, 0xC1, 0xC0, 0xC3, 0xC0, 0xC1, 0xC0>>
  end

  test "Lorem ipsum dolor sit amet, consectetur adipisicing elit" do
    assert RLP.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit") ==
             <<0xB8, 0x38>> <> "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
  end

  test "Big number" do
    assert RLP.encode(15_000_000_000_000_000_000_000_000_000_000_000) ==
             <<143, 2, 227, 142, 158, 4, 75, 160, 83, 84, 85, 150, 0, 0, 0, 0>>
  end

  test "" do
    assert RLP.encode(for _ <- 1..60, do: []) ==
             <<248, 60, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192,
               192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192,
               192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192,
               192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192>>
  end
end
