defmodule Aoc23.P03 do
  @input_file Path.join(["lib", "P03-grid-neighbors", "input.txt"])
  @test_file Path.join(["lib", "P03-grid-neighbors", "test.txt"])

  @spec input_file() :: <<_::256>>
  def input_file, do: @input_file
  @spec test_file() :: <<_::248>>
  def test_file, do: @test_file

  def run(path) do
    lines = Aoc23.file_handle_to_lines(path)
    {nchars, schars} = lines
    |> Enum.with_index()
    |> Enum.map(fn {l, index} -> parse_line(l, index) end)
    |> Enum.unzip()
    |> then(fn {nums, chars} -> {List.flatten(nums), List.flatten(chars)} end)

    symbolPoints = schars
    |> Enum.map(fn s -> {s.x, s.y} end)

    nchars
    |> Enum.map(fn num -> get_part_value(num, symbolPoints) end)
    |> Enum.sum()
  end

  def get_part_value(numberChar, symbolChars) do
    boundary_coords = get_boundary_coords(numberChar)
    # IO.puts "get_part_value #{numberChar.value}, x: (#{numberChar.x_min}..#{numberChar.x_max}), y: #{numberChar.y}"

    symbolChars
    |> Enum.any?(fn {x, y} -> {x, y} in boundary_coords end)
    |> then(fn scorable -> if scorable do numberChar.value else 0 end end)
  end

  def get_boundary_coords(numberChar) do
    # x range is 1 fewer than .. 1 more than numberChar.x_range
    x_range = (numberChar.x_min-1..numberChar.x_max+1)
    # IO.inspect(x_range)

    top_bottom_points = x_range
    |> Enum.map(fn x -> make_vertical_points(x, numberChar.y) end)
    |> List.flatten()

    left = make_point(numberChar.x_min-1, numberChar.y)
    right = make_point(numberChar.x_max+1, numberChar.y)
    [left, right | top_bottom_points]
  end

  # y values are 1 more or 1 less
  def make_vertical_points(x, y) do
    [{x, y+1}, {x, y-1}]
  end

  def make_point(x, y) do
    {x, y}
  end

  def run2(path) do
    _lines = Aoc23.file_handle_to_lines(path)

    nil
  end

  # defmodule CoordPoint do
  #   defstruct [:x, :y]
  # end

  # x and y are 0 indexed
  defmodule SymbolChar do
    defstruct [:x, :y, :type]
  end

  defmodule NumberChars do
    defstruct [:value, :x_min, :x_max, :y]
  end

  @doc """
  Turn a line into two lists of NumberChars and SymbolChars
  """
  def parse_line(str, y) do
    {parse_numbers(str, y), parse_chars(str, y)}
  end

  @spec parse_numbers(binary(), any()) :: any()
  def parse_numbers(str, y) do
    # IO.puts("parse_numbers: y: #{y}, str: #{str}")
    Regex.scan(~r/\d+/, str, return: :index)
    |> List.flatten()
    |> Enum.reduce([], fn {offset, length}, acc ->
      v = String.slice(str, offset, length) |> to_integer!()
      nc = %NumberChars{value: v, x_min: offset, x_max: (offset + length - 1), y: y}
      # we get one character "for free" - a single digit number would be x_min: offset, x_max: offset
      [nc | acc]
    end)
  end

  @spec parse_chars(binary(), any()) :: any()
  def parse_chars(str, y) do
    # ["*", "&", "$", "-", "+", "%", "/", "#", "=", "@"]
    Regex.scan(~r/\*|\&|\$|\-|\+|\%|\/|\#|\=|\@/, str, return: :index)
    |> List.flatten()
    |> Enum.reduce([], fn {offset, length}, acc ->
      t = String.slice(str, offset, length)
      sc = %SymbolChar{type: t, x: offset, y: y}
      [sc | acc]
    end)
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end
end
