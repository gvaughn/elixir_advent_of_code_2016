# `elixir day1.exs` for results
defmodule Day1 do

  def net_distance(steps), do: travel(steps, &List.last/1)

  def first_revisit_distance(steps), do: travel(steps, &first_revisit(&1, nil))

  defp travel(steps, extractor_fn) do
    {coordinates, _} = steps
      |> String.split(", ")
      |> Enum.flat_map_reduce({0, 0, :n}, fn cmd, pos ->
        [dir, len_str] = String.split(cmd, ~r{}, parts: 2)
        new_pos = pos |> turn(dir) |> step(String.to_integer(len_str))
        {new_pos, List.last(new_pos)}
      end)

    coordinates
      |> extractor_fn.()
      |> manhattan_distance
  end

  @turn %{"R" => [n: :e, e: :s, s: :w, w: :n], "L" => [n: :w, w: :s, s: :e, e: :n]}
  defp turn({x, y, h}, dir), do: {x, y, @turn[dir][h]}

  defp step({x, y, :n}, len), do: Enum.map((y+1)..(y+len), &{x, &1, :n})
  defp step({x, y, :e}, len), do: Enum.map((x+1)..(x+len), &{&1, y, :e})
  defp step({x, y, :s}, len), do: Enum.map((y-1)..(y-len), &{x, &1, :s})
  defp step({x, y, :w}, len), do: Enum.map((x-1)..(x-len), &{&1, y, :w})

  defp first_revisit([], match), do: match
  defp first_revisit([candidate | rest], nil) do
    first_revisit(rest, Enum.find(rest, &xy_match(candidate, &1)))
  end
  defp first_revisit(_, success), do: success

  defp xy_match({x1, y1, _}, {x2, y2, _}), do: x1 == x2 && y1 == y2

  defp manhattan_distance({x, y, _}), do: abs(x) + abs(y)
  defp manhattan_distance(_), do: nil
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
