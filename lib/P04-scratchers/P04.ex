defmodule Aoc23.P04 do
  alias Aoc23.P04.TicketTally

  @input_file Path.join(["lib", "P04-scratchers", "input.txt"])
  @test_file Path.join(["lib", "P04-scratchers", "test.txt"])
  # @all_chars_regex ~r/\*|\&|\$|\-|\+|\%|\/|\#|\=|\@/
  # Regex.scan(@all_chars_regex, str, return: :index)
  # -> [[{1, 1}], [{5, 1}]]

  def input_file, do: @input_file
  def test_file, do: @test_file

  defmodule Scratcher do
    defstruct [:desired, :owned, :score]
  end

  defmodule TicketTally do
    defstruct [:line_number, :line_score, :multiplier]
  end


  def run(path) do
    Aoc23.file_handle_to_lines(path)
    |> Enum.map(fn l -> score_line(l, true) end)
    |> Enum.sum()
  end

  @spec score_line(binary(), any()) :: integer()
  def score_line(line, exponential) do
    [_descriptor, number_str] = String.split(line, ": ")
    s = parse_scratcher(number_str, exponential)

    s.score
  end

  @spec parse_scratcher(binary(), any()) :: %Aoc23.P04.Scratcher{
          desired: list(),
          owned: list(),
          score: integer()
        }
  def parse_scratcher(number_str, exponential) do
    [desired, owned] = String.split(number_str, "|")
    s = %Scratcher{desired: parse_ticket_num_string(desired), owned: parse_ticket_num_string(owned)}
    %Scratcher{s | score: score(s, exponential)}
  end

  @spec parse_ticket_num_string(binary()) :: list()
  def parse_ticket_num_string(str) do
    String.split(str, " ")
    |> Enum.map(fn s -> String.trim(s) end)
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.map(fn s -> to_integer!(s) end)
  end

  def score(%Scratcher{desired: d, owned: o}, exponential) do
    case num_overlapping(d, o) do
      0 -> 0
      n -> if exponential do 2 ** (n - 1) else n end
    end
  end

  def run2(path) do
    tallies = Aoc23.file_handle_to_lines(path)
    |> Enum.map(fn l -> score_line(l, false) end)
    |> Enum.with_index(1)
    |> Enum.map(fn {score, index} ->
      %TicketTally{line_number: index, line_score: score, multiplier: 1}
    end)

    scored_tallies = (0..(length(tallies)-1))
    |> Enum.to_list()
    |> List.foldl(tallies, fn(index, tallies) ->
      tally = Enum.at(tallies, index)
      distribute_line_score(tally, tallies)
    end)

    IO.inspect(scored_tallies)

    scored_tallies
    |> Enum.reduce(0, fn el, acc ->
      acc + el.multiplier
    end)
  end

  def distribute_line_score(t, tallies) do
    if t.line_score > 0 do
      range = t.line_number..(t.line_number+t.line_score-1)

      range
      |> Enum.reduce(tallies, fn r, acc ->
        List.update_at(acc, r, fn el -> %TicketTally{el | multiplier: el.multiplier + t.multiplier} end)
      end)
    else
      tallies
    end
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end

  @spec num_overlapping(any(), any()) :: non_neg_integer()
  def num_overlapping(l1, l2) do
    MapSet.size(MapSet.intersection(MapSet.new(l1), MapSet.new(l2)))
  end
end
