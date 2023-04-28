defmodule CompressXor do
  @moduledoc """
Values are compressed using an XOR scheme that works well when successive values are close to each other. When values are close to each other, exponent, sign, and most likely the initial bits of the mantissa will be the same.

The algorithm is:

* The first value, $$v_{-1}$$ is stored with no compression as a double-precision 64 bit float.
* For subsequent values $$v_n$$, calculate the XOR with $$v_{n-1}$$, then
  * If the XOR is zero (same value), store a single '0' bit,
  * If the XOR is non-zero, calculate the number of leading and trailing zeroes in the XOR, then either:
    * If the block of meaningful bits falls within the block of previous value's meaningful bits, store '10' and then the meaningful bits matching the previous block size,
    * Otherwise, store '11', the number of leading zeroes in 5 bits, the length of the meaningful bits in 6 bits, then the meaningful bits of the XORed value.
  """
  import Bitwise

  def start(value) do
    {<<value::float>>, {:binary.decode_unsigned(<<value::float>>), 0, 0}}
  end

  def next(value, {prev_val, prev_leading, prev_trailing}) do
    as_bits = :binary.decode_unsigned(<<value::float>>)

    case bxor(prev_val, as_bits) do
      0 ->
        {<<0::1>>, {as_bits, 0, 0}}

      xor ->
        xor64 = <<xor::64>>
        leading = leading_bits(xor64)
        trailing = trailing_bits(xor64)
        meaningful_bits = 64 - leading - trailing
        xor_shifted = bsr(xor, trailing)
        if leading == prev_leading and trailing == prev_trailing do
          # Same as previous, just the XOR
          {<<0b10::2, xor_shifted::size(meaningful_bits)>>, {as_bits, leading, trailing}}
        else
          # Send the bit sizes out as well
          {<<0b11::2, leading::5, meaningful_bits::6, xor_shifted::size(meaningful_bits)>>, {as_bits, leading, trailing}}
        end
    end
  end

  # This is a single machine code (LZCNT/TZCNT) so for an actual implementation probably
  # needs benchmarking and, if needed, a Rust routine
  for bitcount <- 64..0 do
    def leading_bits(<<0::size(unquote(bitcount)), _::size(64 - unquote(bitcount))>>),
      do: unquote(bitcount)
    A

    def trailing_bits(<<_::size(64 - unquote(bitcount)), 0::size(unquote(bitcount))>>),
      do: unquote(bitcount)
  end
end
