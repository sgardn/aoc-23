defmodule Aoc23.P03 do
  @input_file Path.join(["lib", "P03-grid-neighbors", "input.txt"])
  @test_file Path.join(["lib", "P03-grid-neighbors", "test.txt"])
  @all_chars_regex ~r/\*|\&|\$|\-|\+|\%|\/|\#|\=|\@/
  @stars_only_regex ~r/\*/

  @spec input_file() :: <<_::256>>
  def input_file, do: @input_file
  @spec test_file() :: <<_::248>>
  def test_file, do: @test_file

    # x and y are 0 indexed
    defmodule SymbolChar do
      defstruct [:x, :y, :type]
    end

    defmodule NumberChars do
      defstruct [:value, :x_min, :x_max, :y]
    end

  def run(path) do
    lines = Aoc23.file_handle_to_lines(path)
    {nchars, schars} = lines
    |> Enum.with_index()
    |> Enum.map(fn {l, index} -> parse_line(l, index, false) end)
    |> Enum.unzip()
    |> then(fn {nums, chars} -> {List.flatten(nums), List.flatten(chars)} end)

    symbolPoints = schars
    |> Enum.map(fn s -> {s.x, s.y} end)

    nchars
    |> Enum.map(fn num -> get_part_value(num, symbolPoints) end)
    |> Enum.sum()
  end

  def run2(path) do
    {nchars, schars} = Aoc23.file_handle_to_lines(path)
    |> Enum.with_index()
    |> Enum.map(fn {l, index} -> parse_line(l, index, true) end)
    |> Enum.unzip()
    |> then(fn {nums, chars} -> {List.flatten(nums), List.flatten(chars)} end)

    schars
    |> Enum.map(fn star -> get_gear_value(star, nchars) end)
    |> Enum.sum()
  end

  def get_gear_value(star, numChars) do
    star_neighbors = get_boundary_coords(star)
    neighbors = numChars
    |> Enum.filter(fn nc -> overlap?(star_neighbors, get_number_coords(nc)) end)

    if length(neighbors) > 1 do
      neighbors
      |> Enum.reduce(1, fn nc, acc -> acc * nc.value end)
    else
      0
    end
  end

  def overlap?(l1, l2) do
    not Enum.empty?(MapSet.intersection(MapSet.new(l1), MapSet.new(l2)))
  end

  def get_part_value(numberChar, symbolChars) do
    boundary_coords = get_boundary_coords(numberChar)
    # IO.puts "get_part_value #{numberChar.value}, x: (#{numberChar.x_min}..#{numberChar.x_max}), y: #{numberChar.y}"

    symbolChars
    |> Enum.any?(fn {x, y} -> {x, y} in boundary_coords end)
    |> then(fn scorable -> if scorable do numberChar.value else 0 end end)
  end

  def get_boundary_coords(%NumberChars{value: _v, x_min: x_min, x_max: x_max, y: y}) do
    x_range = (x_min-1..x_max+1)

    top_bottom_points = x_range
    |> Enum.map(fn x -> make_vertical_points(x, y) end)
    |> List.flatten()

    left = make_point(x_min-1, y)
    right = make_point(x_max+1, y)
    [left, right | top_bottom_points]
  end

  def get_boundary_coords(%SymbolChar{type: _t, x: x, y: y}) do
    x_range = (x-1..x+1)

    top_bottom_points = x_range
    |> Enum.map(fn x -> make_vertical_points(x, y) end)
    |> List.flatten()

    left = make_point(x-1, y)
    right = make_point(x+1, y)
    [left, right | top_bottom_points]
  end

  def get_number_coords(%NumberChars{value: _v, x_min: x_min, x_max: x_max, y: y}) do
    x_min..x_max
    |> Enum.map(fn x -> make_point(x, y) end)
  end

  # y values are 1 more or 1 less
  def make_vertical_points(x, y) do
    [{x, y+1}, {x, y-1}]
  end

  def make_point(x, y) do
    {x, y}
  end

  @doc """
  Turn a line into two lists of NumberChars and SymbolChars
  """
  def parse_line(str, y, selective_chars) do
    regex = if selective_chars do @stars_only_regex else @all_chars_regex end
    {parse_numbers(str, y), parse_chars(str, y, regex)}
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

  @spec parse_chars(binary(), any(), Regex.t()) :: any()
  def parse_chars(str, y, regex) do
    # ["*", "&", "$", "-", "+", "%", "/", "#", "=", "@"], or just "*"
    Regex.scan(regex, str, return: :index)
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
