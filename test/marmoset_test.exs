defmodule MarmosetTest do
  use ExUnit.Case
  doctest Marmoset

  test "greets the world" do
    assert Marmoset.hello() == :world
  end
end
