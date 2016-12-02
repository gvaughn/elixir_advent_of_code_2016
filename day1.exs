# `elixir day1.exs for results`
defmodule Day1 do
  @start {0,0,"N"}

  def net_distance(steps) do
    {_, last} = travel(steps)
    distance(last)
  end

  def first_revisit_distance(steps) do
    {stops, _} = travel(steps)
    [@start | stops]
    |> Stream.chunk(2, 1)
    |> Stream.flat_map(&expand_path/1)
    |> Enum.dedup
    |> first_revisit(nil)
    |> distance
  end

  defp travel(steps) do
    steps
    |> String.split(", ")
    |> Enum.map_reduce(@start, fn cmd, pos ->
      [dir, len_str] = String.split(cmd, ~r{}, parts: 2)
      new_pos = pos |> turn(dir) |> step(String.to_integer(len_str))
      {new_pos, new_pos}
    end)
  end

  for {curr, turn, result} <- [{"N", "R", "E"}, {"E", "R", "S"}, {"S", "R", "W"}, {"W", "R", "N"}, {"N", "L", "W"}, {"E", "L", "N"}, {"S", "L", "E"}, {"W", "L", "S"}] do
    defp turn({x, y, unquote(curr)}, unquote(turn)), do: {x, y, unquote(result)}
  end

  defp step({x, y, "N"}, len), do: {x,       y + len, "N"}
  defp step({x, y, "E"}, len), do: {x + len, y,       "E"}
  defp step({x, y, "S"}, len), do: {x,       y - len, "S"}
  defp step({x, y, "W"}, len), do: {x - len, y,       "W"}

  defp expand_path([{x,  y1, _}, {x,  y2, _}]), do: Stream.map(y1..y2, &{x, &1, nil})
  defp expand_path([{x1, y,  _}, {x2, y,  _}]), do: Stream.map(x1..x2, &{&1, y, nil})

  defp first_revisit([],             match  ), do: match
  defp first_revisit([match | rest], nil    ), do: first_revisit(rest, Enum.find(rest, &Kernel.==(match, &1)))
  defp first_revisit(_,              success), do: success

  defp distance({x, y, _}), do: abs(x) + abs(y)
end

ExUnit.start

defmodule Day1Test do
  use ExUnit.Case, async: true
  @input "R1, R3, L2, L5, L2, L1, R3, L4, R2, L2, L4, R2, L1, R1, L2, R3, L1, L4, R2, L5, R3, R4, L1, R2, L1, R3, L4, R5, L4, L5, R5, L3, R2, L3, L3, R1, R3, L4, R2, R5, L4, R1, L1, L1, R5, L2, R1, L2, R188, L5, L3, R5, R1, L2, L4, R3, R5, L3, R3, R45, L4, R4, R72, R2, R3, L1, R1, L1, L1, R192, L1, L1, L1, L4, R1, L2, L5, L3, R5, L3, R3, L4, L3, R1, R4, L2, R2, R3, L5, R3, L1, R1, R4, L2, L3, R1, R3, L4, L3, L4, L2, L2, R1, R3, L5, L1, R4, R2, L4, L1, R3, R3, R1, L5, L2, R4, R4, R2, R1, R5, R5, L4, L1, R5, R3, R4, R5, R3, L1, L2, L4, R1, R4, R5, L2, L3, R4, L4, R2, L2, L4, L2, R5, R1, R4, R3, R5, L4, L4, L5, L5, R3, R4, L1, L3, R2, L2, R1, L3, L5, R5, R5, R3, L4, L2, R4, R5, R1, R4, L3"

  test "example 1",      do: assert  5 = Day1.net_distance("R2, L3")
  test "example 2",      do: assert  2 = Day1.net_distance("R2, R2, R2")
  test "example 3",      do: assert 12 = Day1.net_distance("R5, L5, R5, R3")
  test "part 2 example", do: assert  4 = Day1.first_revisit_distance("R8, R4, R4, R8")

  test "part 1 overall net distance" do
    distance = Day1.net_distance(@input)
    IO.puts "Net distance is: #{distance}"
    assert 307 = distance
  end

  test "part 2 distance to first revisit" do
    distance = Day1.first_revisit_distance(@input)
    IO.puts "Distance to first revisited location: #{distance}"
    assert 165 = distance
  end
end
