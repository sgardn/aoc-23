defmodule Aoc23.P01 do
  @input_file Path.join(["lib", "P01-regex", "input.txt"])

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

  @spec get_string_score(binary()) :: :error | {integer(), binary()}
  def get_string_score(str) do
    {val, _rem} = Integer.parse(String.first(str) <> String.last(str))
    val
  end
end
