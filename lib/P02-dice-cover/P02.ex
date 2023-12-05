defmodule Aoc23.P02 do
  alias Aoc23.P02.Draw
  alias Aoc23.P02.Round
  alias Aoc23.P02.Game

  @input_file Path.join(["lib", "P02-dice-cover", "input.txt"])
  def input_file, do: @input_file
  @test_file Path.join(["lib", "P02-dice-cover", "test.txt"])
  def test_file, do: @test_file

  def run(path) do
    lines = Aoc23.file_handle_to_lines(path)

    lines
    |> Enum.map(fn l -> parse_game(l) end)
    |> Enum.map(fn g -> get_game_value(g) end)
    |> Enum.sum
  end

  def run2(path) do
    lines = Aoc23.file_handle_to_lines(path)

    lines
    |> Enum.map(fn l -> parse_game(l) end)
    |> Enum.map(fn g -> get_min_cubes_product(g) end)
    |> Enum.sum
  end

  def get_min_cubes_product(game) do
    base = %{"red" => 0, "blue" => 0, "green" => 0}

    game.rounds
    |> Enum.reduce(base, fn r, acc -> bump_required_pulls(r, acc) end)
    |> product_score()
  end

  def get_game_value(game) do
    base = %{"red" => 0, "blue" => 0, "green" => 0}

    game.rounds
    |> Enum.reduce(base, fn r, acc -> bump_required_pulls(r, acc) end)
    |> score_from_map_and_id(game.id)
  end

  def product_score(map) do
    map["red"] * map["blue"] * map["green"]
  end

  def bump_required_pulls(round, map) do
    round.draws
    |> Enum.reduce(map, fn d, acc ->
      higher = Enum.max([acc[d.color], d.amount])
      %{ acc | d.color => higher }
    end)
  end

  def score_from_map_and_id(scores_map, id) do
    limit = %{"red" => 12, "blue" => 14, "green" => 13}
    if scores_map["red"] <= limit["red"] and scores_map["blue"] <= limit["blue"] and scores_map["green"] <= limit["green"] do
      id
    else
      0
    end
  end

  defmodule Draw do
    defstruct [:color, :amount]
  end

  defmodule Round do
    defstruct [:draws]
  end

  defmodule Game do
    defstruct [:id, :rounds]
  end

  @spec parse_game(binary()) :: %Aoc23.P02.Game{rounds: any(), id: integer()}
  def parse_game(str) do
    [description, contents] = String.split(str, ": ")

    contents
    |> String.split("; ")
    |> Enum.map(fn g -> parse_round(g) end)
    |> build_game(description)
  end

  @spec build_game(any(), binary()) :: %Aoc23.P02.Game{rounds: any(), id: integer()}
  def build_game(rounds, description) do
    id = get_first_digits!(description)

    %Game{rounds: rounds, id: id}
  end

  @spec parse_round(binary()) :: %Aoc23.P02.Round{draws: any()}
  def parse_round(str) do
    str
    |> String.split(", ")
    |> Enum.map(fn draw -> build_draw(draw) end)
    |> build_round()
  end

  @spec build_draw(binary()) :: %Aoc23.P02.Draw{amount: integer(), color: binary()}
  def build_draw(str) do
    [amount, color] = String.split(str, " ")
    %Draw{color: color, amount: to_integer!(amount)}
  end

  @spec build_round(any()) :: %Aoc23.P02.Round{draws: any()}
  def build_round(draws) do
    %Round{draws: draws}
  end

  @spec get_first_digits!(binary()) :: integer()
  def get_first_digits!(str) do
    digits_pattern = ~r/\d+/

    case Regex.run(digits_pattern, str) do
      [first | _] -> to_integer!(first)
    end
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end
end
