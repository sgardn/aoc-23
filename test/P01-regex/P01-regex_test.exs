defmodule Aoc23Test.P01 do
  use ExUnit.Case

  # @tag :pending
  test "P01-regex part one" do
    assert 54573 == Aoc23.P01.run()
  end

  # @tag :focus
  test "P01-regex part two" do
    assert 54591 == Aoc23.P01.run2(Aoc23.P01.input_file())
  end

  test "P01-regex part two with 'known' output" do
    assert 281 == Aoc23.P01.run2(Aoc23.P01.test_file())
  end

  describe "gentle_words_to_digits" do
    test "allows for converting overlapping digits" do
      assert Aoc23.P01.gentle_words_to_digits("oneight") == "o1e8t"
      assert Aoc23.P01.gentle_words_to_digits("twone") == "t2o1e"
    end

    test "works on single number words" do
      assert Aoc23.P01.gentle_words_to_digits("one") == "o1e"
      assert Aoc23.P01.gentle_words_to_digits("two") == "t2o"
      assert Aoc23.P01.gentle_words_to_digits("three") == "t3e"
      assert Aoc23.P01.gentle_words_to_digits("four") == "f4r"
      assert Aoc23.P01.gentle_words_to_digits("five") == "f5e"
      assert Aoc23.P01.gentle_words_to_digits("six") == "s6x"
      assert Aoc23.P01.gentle_words_to_digits("seven") == "s7n"
      assert Aoc23.P01.gentle_words_to_digits("eight") == "e8t"
      assert Aoc23.P01.gentle_words_to_digits("nine") == "n9e"
    end
  end
end
