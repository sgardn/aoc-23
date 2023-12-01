defmodule Aoc23Test do
  use ExUnit.Case
  doctest Aoc23

  test "greets the world" do
    assert Aoc23.hello() == :world
  end

  test "P01-regex" do
    assert 1 == 1
    refute 1 == 2
    refute 1 == Aoc23.P01.run()
  end
end
