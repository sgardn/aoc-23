defmodule Aoc23.P01 do
  @input_file Path.join(["lib", "P01-regex", "input.txt"])
  @spec input_file() :: <<_::184>>
  def input_file, do: @input_file
  @test_file Path.join(["lib", "P01-regex", "test.txt"])
  @spec test_file() :: <<_::176>>
  def test_file, do: @test_file

  @spec run() :: number()
  def run() do
    {:ok, lines} = File.read(@input_file)
    lines
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.replace(~r/\D/, "")
      |> get_string_score()
    end)
    |> Enum.sum()
  end

  @spec get_string_score(binary()) :: integer()
  def get_string_score(str) do
    {val, _rem} = Integer.parse(String.first(str) <> String.last(str))
    val
  end

  @spec run2(<<_::184>>) :: number()
  def run2(file \\ @input_file) do
    {:ok, lines} = File.read(file)
    total = lines
    |> String.split("\n")
    |> Enum.map(fn s -> get_line_score(s) end)
    |> Enum.sum()

    total
  end

  @spec get_line_score(any()) :: integer()
  def get_line_score(str) do
    amended = gentle_words_to_digits(str)

    # replace all other nonesense letters
    cleaned = amended
    |> String.replace(~r/\D/, "")

    # compute based on first / last
    {val, _rem} = Integer.parse(String.first(cleaned) <> String.last(cleaned))

    # IO.puts("#{str} -> #{amended} -> #{cleaned} -> #{val}")
    val
  end

  # it's not ultimately clear from the toy example if we should find the last digit by "preferring" later words
  # and that's what I suspect is broken about my solution
  # given that the number words have at most ONE letter of overlap
  # it's safe to replace in place, ex: "nine" -> "n9e"
  # this means that a string consisting of "nineight" will become "n9ee8t" -> "98" instead of just "9"
  @spec gentle_words_to_digits(binary()) :: binary()
  def gentle_words_to_digits(line) do
    line
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end
end
