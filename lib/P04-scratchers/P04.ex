defmodule Aoc23.P04 do
  @input_file Path.join(["lib", "P04-scratchers", "input.txt"])
  @test_file Path.join(["lib", "P04-scratchers", "test.txt"])
  # @all_chars_regex ~r/\*|\&|\$|\-|\+|\%|\/|\#|\=|\@/
  # Regex.scan(@all_chars_regex, str, return: :index)
  # -> [[{1, 1}], [{5, 1}]]

  def input_file, do: @input_file
  def test_file, do: @test_file

  # just
  defmodule Scratcher do
    defstruct [:desired, :owned]
  end


  def run(path) do
    Aoc23.file_handle_to_lines(path)
    |> Enum.map(fn l -> score_line(l) end)
    |> Enum.sum()
  end

  def score_line(line) do
    [_descriptor, number_str] = String.split(line, ": ")

    s = parse_scratcher(number_str)
    IO.inspect(s)

    score = score(s)
    IO.puts("score: #{score} (line: #{line})")

    score
  end

  def parse_scratcher(number_str) do
    [desired, owned] = String.split(number_str, "|")
    IO.puts("parse_scratcher(#{number_str})")
    IO.puts("#{desired}, #{owned}")

    %Scratcher{desired: parse_ticket_num_string(desired), owned: parse_ticket_num_string(owned)}
  end

  def parse_ticket_num_string(str) do
    IO.puts("parse_ticket_num_string(#{str})")
    # IO.puts("#{desired}, #{owned}")
    ns = String.split(str, " ")
    |> Enum.map(fn s -> String.trim(s) end)
    |> Enum.filter(fn s -> s != "" end)
    IO.inspect(ns)

    ns
    |> Enum.map(fn s -> to_integer!(s) end)
  end

  def score(%Scratcher{desired: d, owned: o}) do
    case num_overlapping(d, o) do
      0 -> 0
      n -> 2 ** (n - 1)
    end
  end

  def run2(_path) do
    0
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end

  def num_overlapping(l1, l2) do
    MapSet.size(MapSet.intersection(MapSet.new(l1), MapSet.new(l2)))
  end
end
