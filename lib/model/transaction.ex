defmodule Transaction do
  defstruct [:nonce, :gas_price, :gas_limit, :to, :value, :init, :data, :v, :r, :s]

  def from_binary([nonce, gas_price, gas_limit, to, value, init_or_data, v, r, s]) do
    transaction = %Transaction{
      nonce: :binary.decode_unsigned(nonce),
      gas_price: :binary.decode_unsigned(gas_price),
      gas_limit: :binary.decode_unsigned(gas_limit),
      to: Base.encode16(to, case: :lower),
      value: :binary.decode_unsigned(value),
      v: Base.encode16(v, case: :lower),
      r: Base.encode16(r, case: :lower),
      s: Base.encode16(s, case: :lower)
    }

    case transaction.to do
      addr when addr in ["", <<128>>] -> Map.put(transaction, :init, init_or_data)
      true -> Map.put(transaction, :data, init_or_data)
    end
  end
end
