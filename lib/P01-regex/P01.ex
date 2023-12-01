defmodule Aoc23.P01 do
  @input_file Path.join(["lib", "P01-regex", "input.txt"])
  @spec input_file() :: <<_::184>>
  def input_file, do: @input_file
  @test_file Path.join(["lib", "P01-regex", "test.txt"])
  @spec test_file() :: <<_::176>>
  def test_file, do: @test_file

  @replacement_set MapSet.new(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"])
  @replacements %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
  }

  @spec run() :: number()
  def run do
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

    # IO.puts(total)
    total
  end

  @spec get_line_score(any()) :: integer()
  def get_line_score(str) do
    # amended = loop_scan_replace(str)
    amended = gentle_words_to_digits(str)

    # then replace all other nonesense letters
    cleaned = amended
    |> String.replace(~r/\D/, "")

    # then, compute based on first / last
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

  @spec loop_scan_replace(binary()) :: binary()
  def loop_scan_replace(str) do
    case scan(str, 0) do
      {_offset, word} ->
        replacement = @replacements[word]

        str
        |> String.replace(word, replacement, global: false)
        |> loop_scan_replace()
      _ -> str
    end
  end

  def scan(str, offset) do
    # IO.puts("scan(#{str}, #{offset})")
    slice_length = String.length(str) - offset

    if slice_length < 3 do
      # we've run out of characters, no matches possible
      nil
    else
      substring = String.slice(str, offset, slice_length)
      words = get_candidates(substring)
      # IO.puts("get_candidates(#{substring}) ->")
      # IO.inspect(words)

      if m = get_match?(words, @replacement_set) do
        {offset, m}
      else
        scan(str, offset + 1)
      end
    end
  end

  @spec get_candidates(binary()) :: MapSet.t()
  def get_candidates(str) do
    # IO.puts("get_candidates(#{str})")
    len = String.length(str)
    # max length is min of 5 and string.length
    limit = Enum.min([len, 5])

    (3..limit)
    |> Enum.to_list
    |> Enum.map(fn l -> String.slice(str, 0..(l-1)) end)
    |> MapSet.new()
  end

  def get_match?(m, n) do
    MapSet.intersection(m,n) |> MapSet.to_list |> Enum.at(0)
  end
end
