defmodule Aoc23Test.P03 do
  use ExUnit.Case

  alias Aoc23.P03.NumberChars

  @small_number %NumberChars{x_min: 1, x_max: 1, y: 0, value: 2}
  @long_number %NumberChars{x_min: 3, x_max: 6, y: 2, value: 4123}

  # @tag :focus
  describe "P03-dice-cover part one (sum of games that touch ops)" do
    test "test input" do
      assert 4361 == Aoc23.P03.run(Aoc23.P03.test_file())
    end

    test "real input" do
      assert 533775 == Aoc23.P03.run(Aoc23.P03.input_file())
    end
  end

  describe "P03-dice-cover part two (gear values for numbers pairs touching *s)" do
    test "test input" do
      assert 467835 == Aoc23.P03.run2(Aoc23.P03.test_file())
    end

    test "real input" do
      assert 78236071 == Aoc23.P03.run2(Aoc23.P03.input_file())
    end
  end

  describe "calculating boundaries" do
    test "a single digit number should have eight boundary cells" do
      bounds = Aoc23.P03.get_boundary_coords(@small_number)
      assert length(bounds) == 8

      # top side
      assert {0, -1} in bounds
      assert {1, -1} in bounds
      assert {2, -1} in bounds

      # left
      assert {-0, 0} in bounds

      # right
      assert {2, 0} in bounds

      # bottom
      assert {-0, 1} in bounds
      assert {1, 1} in bounds
      assert {2, 1} in bounds
    end

    test "a four digit number should have fourteen boundary cells" do
      bounds = Aoc23.P03.get_boundary_coords(@long_number)
      assert length(bounds) == 14

      # top side
      assert {2, 1} in bounds
      assert {3, 1} in bounds
      assert {4, 1} in bounds
      assert {5, 1} in bounds
      assert {6, 1} in bounds
      assert {7, 1} in bounds

      # left
      assert {2, 2} in bounds

      # right
      assert {7, 2} in bounds

      # bottom
      assert {2, 3} in bounds
      assert {3, 3} in bounds
      assert {4, 3} in bounds
      assert {5, 3} in bounds
      assert {6, 3} in bounds
      assert {7, 3} in bounds
    end
  end
end
