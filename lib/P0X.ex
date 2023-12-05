defmodule Aoc23.P0X do
  @input_file Path.join(["lib", "P03-grid-neighbors", "input.txt"])
  @test_file Path.join(["lib", "P03-grid-neighbors", "test.txt"])
  # @all_chars_regex ~r/\*|\&|\$|\-|\+|\%|\/|\#|\=|\@/
  # Regex.scan(@all_chars_regex, str, return: :index)
  # -> [[{1, 1}], [{5, 1}]]

  @spec input_file() :: <<_::256>>
  def input_file, do: @input_file
  @spec test_file() :: <<_::248>>
  def test_file, do: @test_file

  # x and y are 0 indexed
  defmodule SymbolChar do
    defstruct [:x, :y, :type]
  end

  def run(path) do
    lines = Aoc23.file_handle_to_lines(path)
    lines
    |> Enum.with_index()
    |> Enum.map(fn {l, index} -> IO.puts("#{index} -> #{l}") end)

    0
  end

  def run2(_path) do
    0
  end

  def get_boundary_coords(%SymbolChar{type: _t, x: x, y: y}) do
    [{x, y}]
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end

  def overlap?(l1, l2) do
    not Enum.empty?(MapSet.intersection(MapSet.new(l1), MapSet.new(l2)))
  end
end
