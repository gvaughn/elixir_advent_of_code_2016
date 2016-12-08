defmodule Day8 do

  @initial_screen for x <- 0..49, y <- 0..5, into: %{}, do: {{x,y}, "."}
  @scanner ~r{(^(rect) (\d+)x(\d+)$)|(^(rotate column) x=(\d+) by (\d+)$)|(^(rotate row) y=(\d+) by (\d+)$)}

  def light_em_up(input, screen \\ @initial_screen) do
    output_screen = input
      |> String.split("\n", trim: true)
      |> Enum.reduce(screen, &instruction/2)
    {output_screen, count(output_screen)}
  end

  def to_s(screen), do: Enum.map_join(0..5, "\n", fn row -> extract_row(screen, row) |> Enum.join end)

  defp instruction(str, screen) when is_binary(str) do
    with [name, p1, p2] <- Regex.run(@scanner, str) |> Enum.slice(-3, 3),
                  parts = [name, String.to_integer(p1), String.to_integer(p2)],
    do: Map.merge(screen, instruction(parts, screen))
  end

  defp instruction(["rect", x, y], _screen), do: for i <- 0..(x-1), j <- 0..(y-1), into: %{}, do: {{i,j}, "#"}

  defp instruction(["rotate column", x, distance], screen) do
    extract_col(screen, x)
    |> rotate_by(6, distance)
    |> Enum.into(%{}, fn {char, y} -> {{x,y}, char} end)
  end

  defp instruction(["rotate row", y, distance], screen) do
    extract_row(screen, y)
    |> rotate_by(50, distance)
    |> Enum.into(%{}, fn {char, x} -> {{x,y}, char} end)
  end

  defp rotate_by(enum, modulo, distance) do
    enum
    |> Stream.cycle
    |> Stream.drop(modulo - distance)
    |> Stream.take(modulo)
    |> Enum.with_index
  end

  defp extract_row(screen, row), do: Enum.filter(screen, &match?({{_, ^row}, _}, &1)) |> to_contents

  defp extract_col(screen, col), do: Enum.filter(screen, &match?({{^col, _}, _}, &1)) |> to_contents

  defp to_contents(screen_subset), do: Enum.sort(screen_subset) |> Enum.map(&elem(&1, 1))

  defp count(screen), do: Enum.count(screen, &match?({_, "#"}, &1))
end

ExUnit.start()

defmodule Day7Test do
  use ExUnit.Case, async: true
  @input File.stream!(__ENV__.file) |> Stream.drop_while(&(&1 != "# ==DATA==\n")) |> Stream.drop(1) |> Stream.map(&String.trim(&1, "# ")) |> Enum.join
  @expected """
####..##...##..###...##..###..#..#.#...#.##...##..
#....#..#.#..#.#..#.#..#.#..#.#..#.#...##..#.#..#.
###..#..#.#..#.#..#.#....#..#.####..#.#.#..#.#..#.
#....#..#.####.###..#.##.###..#..#...#..####.#..#.
#....#..#.#..#.#.#..#..#.#....#..#...#..#..#.#..#.
####..##..#..#.#..#..###.#....#..#...#..#..#..##..
"""
  test "example" do
    {screen, count} = Day8.light_em_up("rect 3x2")
    assert 6 = count
    {screen, count} = Day8.light_em_up("rotate column x=1 by 1", screen)
    assert 6 = count
    {screen, count} = Day8.light_em_up("rotate row y=0 by 4", screen)
    assert 6 = count
    {screen, count} = Day8.light_em_up("rotate column x=1 by 1", screen)
    assert 6 = count
  end

  test "input" do
    {screen, count} = Day8.light_em_up(@input)
    IO.puts Day8.to_s(screen)
    assert 128 = count
    # assert @expected = Day8.to_s(screen)
  end

end

# ==DATA==
# rect 1x1
# rotate row y=0 by 7
# rect 1x1
# rotate row y=0 by 5
# rect 1x1
# rotate row y=0 by 5
# rect 1x1
# rotate row y=0 by 2
# rect 1x1
# rotate row y=0 by 3
# rect 1x1
# rotate row y=0 by 5
# rect 1x1
# rotate row y=0 by 3
# rect 1x1
# rotate row y=0 by 2
# rect 1x1
# rotate row y=0 by 3
# rect 2x1
# rotate row y=0 by 7
# rect 6x1
# rotate row y=0 by 3
# rect 2x1
# rotate row y=0 by 2
# rect 1x2
# rotate row y=1 by 10
# rotate row y=0 by 3
# rotate column x=0 by 1
# rect 2x1
# rotate column x=20 by 1
# rotate column x=15 by 1
# rotate column x=5 by 1
# rotate row y=1 by 5
# rotate row y=0 by 2
# rect 1x2
# rotate row y=0 by 5
# rotate column x=0 by 1
# rect 4x1
# rotate row y=2 by 15
# rotate row y=0 by 5
# rotate column x=0 by 1
# rect 4x1
# rotate row y=2 by 5
# rotate row y=0 by 5
# rotate column x=0 by 1
# rect 4x1
# rotate row y=2 by 10
# rotate row y=0 by 10
# rotate column x=8 by 1
# rotate column x=5 by 1
# rotate column x=0 by 1
# rect 9x1
# rotate column x=27 by 1
# rotate row y=0 by 5
# rotate column x=0 by 1
# rect 4x1
# rotate column x=42 by 1
# rotate column x=40 by 1
# rotate column x=22 by 1
# rotate column x=17 by 1
# rotate column x=12 by 1
# rotate column x=7 by 1
# rotate column x=2 by 1
# rotate row y=3 by 10
# rotate row y=2 by 5
# rotate row y=1 by 3
# rotate row y=0 by 10
# rect 1x4
# rotate column x=37 by 2
# rotate row y=3 by 18
# rotate row y=2 by 30
# rotate row y=1 by 7
# rotate row y=0 by 2
# rotate column x=13 by 3
# rotate column x=12 by 1
# rotate column x=10 by 1
# rotate column x=7 by 1
# rotate column x=6 by 3
# rotate column x=5 by 1
# rotate column x=3 by 3
# rotate column x=2 by 1
# rotate column x=0 by 1
# rect 14x1
# rotate column x=38 by 3
# rotate row y=3 by 12
# rotate row y=2 by 10
# rotate row y=0 by 10
# rotate column x=7 by 1
# rotate column x=5 by 1
# rotate column x=2 by 1
# rotate column x=0 by 1
# rect 9x1
# rotate row y=4 by 20
# rotate row y=3 by 25
# rotate row y=2 by 10
# rotate row y=0 by 15
# rotate column x=12 by 1
# rotate column x=10 by 1
# rotate column x=8 by 3
# rotate column x=7 by 1
# rotate column x=5 by 1
# rotate column x=3 by 3
# rotate column x=2 by 1
# rotate column x=0 by 1
# rect 14x1
# rotate column x=34 by 1
# rotate row y=1 by 45
# rotate column x=47 by 1
# rotate column x=42 by 1
# rotate column x=19 by 1
# rotate column x=9 by 2
# rotate row y=4 by 7
# rotate row y=3 by 20
# rotate row y=0 by 7
# rotate column x=5 by 1
# rotate column x=3 by 1
# rotate column x=2 by 1
# rotate column x=0 by 1
# rect 6x1
# rotate row y=4 by 8
# rotate row y=3 by 5
# rotate row y=1 by 5
# rotate column x=5 by 1
# rotate column x=4 by 1
# rotate column x=3 by 2
# rotate column x=2 by 1
# rotate column x=1 by 3
# rotate column x=0 by 1
# rect 6x1
# rotate column x=36 by 3
# rotate column x=25 by 3
# rotate column x=18 by 3
# rotate column x=11 by 3
# rotate column x=3 by 4
# rotate row y=4 by 5
# rotate row y=3 by 5
# rotate row y=2 by 8
# rotate row y=1 by 8
# rotate row y=0 by 3
# rotate column x=3 by 4
# rotate column x=0 by 4
# rect 4x4
# rotate row y=4 by 10
# rotate row y=3 by 20
# rotate row y=1 by 10
# rotate row y=0 by 10
# rotate column x=8 by 1
# rotate column x=7 by 1
# rotate column x=6 by 1
# rotate column x=5 by 1
# rotate column x=3 by 1
# rotate column x=2 by 1
# rotate column x=1 by 1
# rotate column x=0 by 1
# rect 9x1
# rotate row y=0 by 40
# rotate column x=44 by 1
# rotate column x=35 by 5
# rotate column x=18 by 5
# rotate column x=15 by 3
# rotate column x=10 by 5
# rotate row y=5 by 15
# rotate row y=4 by 10
# rotate row y=3 by 40
# rotate row y=2 by 20
# rotate row y=1 by 45
# rotate row y=0 by 35
# rotate column x=48 by 1
# rotate column x=47 by 5
# rotate column x=46 by 5
# rotate column x=45 by 1
# rotate column x=43 by 1
# rotate column x=40 by 1
# rotate column x=38 by 2
# rotate column x=37 by 3
# rotate column x=36 by 2
# rotate column x=32 by 2
# rotate column x=31 by 2
# rotate column x=28 by 1
# rotate column x=23 by 3
# rotate column x=22 by 3
# rotate column x=21 by 5
# rotate column x=20 by 1
# rotate column x=18 by 1
# rotate column x=17 by 3
# rotate column x=13 by 1
# rotate column x=10 by 1
# rotate column x=8 by 1
# rotate column x=7 by 5
# rotate column x=6 by 5
# rotate column x=5 by 1
# rotate column x=3 by 5
# rotate column x=2 by 5
# rotate column x=1 by 5
