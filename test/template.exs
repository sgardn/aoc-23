defmodule Aoc23Test.P0X do
  use ExUnit.Case

  # alias Aoc23.P02.Draw

  # @test_line "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"

  # @tag :focus
  # @tag :pending
  describe "P0X part one (...)" do
    test "test input" do
      assert 1 == 1
      # assert 8 == Aoc23.P02.run(Aoc23.P02.test_file())
    end

    test "real input" do
      refute 1 == 2
      # assert 2101 == Aoc23.P02.run(Aoc23.P02.input_file())
    end
  end

  describe "P0X part two (...)" do
    test "test input" do
      assert 1 == 1
      # assert 8 == Aoc23.P02.run2(Aoc23.P02.test_file())
    end

    test "real input" do
      refute 1 == 2
      # assert 2101 == Aoc23.P02.run2(Aoc23.P02.input_file())
    end
  end

  # describe "parsing structure" do
  #   test "game ID can be pulled from a line" do
  #     game = Aoc23.P02.parse_game(@test_line)
  #     assert game.id == 1
  #   end

  #   test "the right number of rounds are parsed" do
  #     game = Aoc23.P02.parse_game(@test_line)
  #     assert length(game.rounds) == 3
  #   end

  #   test "games have the correct description of play" do
  #     game = Aoc23.P02.parse_game(@test_line)
  #     firstRound = Enum.at(game.rounds, 0)
  #     assert length(firstRound.draws) == 2
  #     assert Enum.member?(firstRound.draws, %Draw{color: "red", amount: 4})
  #     assert Enum.member?(firstRound.draws, %Draw{color: "blue", amount: 3})
  #   end
  # end
end
