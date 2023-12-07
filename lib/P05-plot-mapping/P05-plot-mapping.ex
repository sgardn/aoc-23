defmodule Aoc23.P05 do
  alias Aoc23.P05.SeedAndMappings
  alias Aoc23.P05.Binding
  alias Aoc23.P05.Map

  @input_file Path.join(["lib", "P05-plot-mapping", "input.txt"])
  @test_file Path.join(["lib", "P05-plot-mapping", "test.txt"])

  @spec input_file() :: <<_::256>>
  def input_file, do: @input_file
  @spec test_file() :: <<_::248>>
  def test_file, do: @test_file

  # %SeedAndMappings{seeds: [10, 5, ...], mappings: [%Map{}, %Map...]}
  defmodule SeedAndMappings do
    defstruct [:seeds, :current_target, mappings: []]
  end

  # %Map{from: :soil, to: :fertilizer, bindings: [Binding%{}, ...]}
  defmodule Map do
    defstruct [:from, :to, :bindings]
  end

  # %Binding{dest_start: 100, source_start: 200, range: 2}
  # 100 -> 200
  # 101 -> 201
  defmodule Binding do
    defstruct [:dest_start, :source_start, :range]
  end

  def run(path) do
    lines = Aoc23.file_handle_to_lines(path)
    sam = lines
    |> Enum.reduce(%SeedAndMappings{}, fn line, acc ->
      case line_type(line) do
        :empty -> acc
        :seeds -> %SeedAndMappings{acc | seeds: parse_seeds(line)}
        :map ->
          m = create_mapping(line)
          %SeedAndMappings{acc | mappings: [m | acc.mappings], current_target: m.from}
        :binding -> insert_binding(line, acc)
      end
    end)

    sam.seeds
    |> Enum.map(fn s ->  traverse(s, sam.mappings) end)
    |> Enum.min()
  end

  def run2(_path) do
    0
  end

  def traverse(n, mappings, current_key \\ "seed")
  def traverse(n, _mappings, "location"), do: n
  def traverse(n, mappings, current_key) do
    # IO.puts("traverse(n: #{n}, current_key: #{current_key}, m: ...)")
    m = find_mapping_with_source(mappings, current_key)
    traverse(get_value_for_bindings(m.bindings, n), mappings, m.to)
  end

  def find_mapping_with_source(mappings, key) do
    mappings
    |> Enum.find(fn m -> m.from == key end)
  end

  def get_value_for_bindings(bindings, n) do
    b? = bindings
    |> Enum.find(fn b ->
      n in b.source_start..(b.source_start + b.range - 1)
    end)

    # if b? do
    #   # IO.inspect(b?)
    #   IO.puts("get_value_for_bindings(n: #{n}, binding range: #{b?.source_start} .. #{b?.source_start + b?.range})")
    # else
    #   IO.puts("no binding found, using same number")
    # end

    get_dest_value(b?, n)
  end

  def get_dest_value(nil, n), do: n
  def get_dest_value(binding, n) do
    n + (binding.dest_start - binding.source_start)
    # offset = binding.source_start - n
    # IO.puts("get_dest_value\n")
    # IO.inspect(binding)
    # offset + binding.dest_start
  end

  @spec parse_seeds(binary()) :: list()
  def parse_seeds(line) do
    [_header, seeds] = String.split(line, ": ")

    String.split(seeds, " ")
    |> Enum.map(fn l -> String.trim(l) end)
    |> Enum.map(fn l -> to_integer!(l) end)
  end

  @spec create_mapping(binary()) :: %Aoc23.P05.Map{bindings: [], from: binary(), to: binary()}
  def create_mapping(line) do
    # "seed-to-soil map:"
    [header, _s] = String.split(line, " map:")
    [from, to] = String.split(header, "-to-")

    %Map{from: from, to: to, bindings: []}
  end

  def create_binding(line) do
    [ds, ss, range] = String.split(line, " ")
    |> Enum.map(fn s -> to_integer!(s) end)

    %Binding{dest_start: ds, source_start: ss, range: range}
  end

  def insert_binding(line, m = %SeedAndMappings{}) do
    b = create_binding(line)

    updated_mappings = m.mappings
    |> Enum.map(fn el ->
      if el.from == m.current_target do
        %Map{from: el.from, to: el.to, bindings: [b | el.bindings]}
      else
        el
      end
    end)

    %SeedAndMappings{mappings: updated_mappings, seeds: m.seeds, current_target: m.current_target}
  end

  def line_type(str) do
    if String.trim(str) == "" do
      :empty
    else
      if String.contains?(str, "seeds:") do
        :seeds
      else
        if String.contains?(str, "map:") do
          :map
        else
          :binding
        end
      end
    end
  end

  @spec to_integer!(binary()) :: integer()
  def to_integer!(str) do
    {digits, _} = Integer.parse(str)
    digits
  end
end
