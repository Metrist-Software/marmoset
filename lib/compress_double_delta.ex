defmodule CompressDoubleDelta do
  @moduledoc """
For metrics series, timestamps are very regular: every 60 seconds, say, with +1 a second difference. Therefore, it's highly effective to store the delta of the delta - "the same delta as the last time, but with 3 seconds difference" instead of "63 seconds difference", say.

The algorithm is:

1. The block header stores the starting time stamp, $$t_{-1}$$, as a full precision timestamp which is a 64 bit number of seconds since the epoch.
2. $$t_0$$ is stored as a 14 bit delta from $$t_{-1}$$
3. $$t_n$$ is stored with the following method:

   * Calculate the delta of the delta: $$\delta = (t_n - t_{n-1}) - (t_{n-1} - t_{n-2})$$, then
   * if $$\delta$$ is zero, store a single '0' bit,
   * if $$-63 <= \delta <= 64$$, store '10' followed by the 7-bit value,
   * if $$-255 <= \delta <= 256$$, store '110' followed by the 9-bit value,
   * if $$-2047 <= \delta <= 2048$$, store '1110' followed by the 12-bit value,
   * otherwise store '1111' followed by the 32-bit value.
  """

  def start(base, d0) do
    {<<(d0 - base)::14-signed-little>>, {base, d0}}
  end
  def next(cur, {pprev, prev}) do
    double_delta = (cur - prev) - (prev - pprev)
    {emit(double_delta), {prev, cur}}
  end
  defp emit(v) when v >= -63 and v <= 64, do: <<0b10::2, v::7-signed-little>>
  defp emit(v) when v >= -255 and v <= 256, do: <<0b110::3, v::9-signed-little>>
  defp emit(v) when v >= -2047 and v <= 2048, do: <<0b1110::4, v::12-signed-little>>
  defp emit(v), do: <<0b1111::4, v::32-signed-little>>
end
