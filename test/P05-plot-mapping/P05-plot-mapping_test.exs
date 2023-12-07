defmodule Aoc23Test.P05 do
  use ExUnit.Case

  # @tag :focus
  # @tag :pending
  describe "P05 part one (...)" do
    test "test input" do
      assert 35 == Aoc23.P05.run(Aoc23.P05.test_file())
    end

    test "real input" do
      assert 218513636 == Aoc23.P05.run(Aoc23.P05.input_file())
    end
  end

  describe "P05 part two (...)" do
    test "test input" do
      assert 46 == Aoc23.P05.run2(Aoc23.P05.test_file())
    end

    test "real input" do
      refute 1 == 2
      # assert 2101 == Aoc23.P02.run2(Aoc23.P02.input_file())
    end
  end
end
