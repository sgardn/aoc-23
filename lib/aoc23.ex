defmodule Aoc23 do
  def file_handle_to_lines(path) do
    case File.read(path) do
      {:ok, lines} ->
        lines
        |> String.split("\n")
      err ->
        IO.puts("Failed to read file! Cause:")
        IO.inspect(err)
    end
  end
end
