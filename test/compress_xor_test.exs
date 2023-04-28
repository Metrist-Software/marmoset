defmodule CompressXorTest do
  use ExUnit.Case, async: true

  test "Leading/trailing bits" do
    assert Enum.map(
      [
        1, 2, 4, 8,
        2_305_843_009_213_693_952 + 8,
        2_305_843_009_213_693_952, 4_611_686_018_427_387_904, 9_223_372_036_854_775_808
      ],
      fn i ->
        {CompressXor.leading_bits(<<i::64-signed>>), CompressXor.trailing_bits(<<i::64-signed>>)}
      end
    )
     == [{63, 0}, {62, 1}, {61, 2}, {60, 3},
         {2, 3},
         {2, 61}, {1, 62}, {0, 63}]

  end

  test "Basic compression examples" do
    {emit, state} = CompressXor.start(12.0)
    assert emit == <<64, 40, 0, 0, 0, 0, 0, 0>>

    # Same value -> emit a 0 bit.
    # 12.0 = 0x4028000000000000
    {emit, _state} = CompressXor.next(12.0, state)
    assert emit == <<0::1>>

    # Different value, leading/meaningful/trailing set.
    # 24.0 = 0x4038000000000000
    # XOR with 12 = 0x0010_0000_0000_0000 so 11 leading, 1 meaningful bit (and this 50 trailing bits)
    {emit, _state} = CompressXor.next(24.0, state)
    assert emit == <<0b11::2, 11::5, 1::6, 1::1>>
  end
end
