defmodule CompressDoubleDeltaTest do
  use ExUnit.Case, async: true

  test "Basic compression" do
    base = :erlang.system_time(:second)
    v0 = base + 61
    v1 = base + 120
    v2 = base + 300
    v3 = base + 5500
    {emit0, state} = CompressDoubleDelta.start(base, v0)
    {emit1, state} = CompressDoubleDelta.next(v1, state)
    {emit2, state} = CompressDoubleDelta.next(v2, state)
    {emit3, state} = CompressDoubleDelta.next(v3, state)

    # TODO assertions
    IO.inspect({emit0, emit1, emit2, emit3, state})
  end
end
