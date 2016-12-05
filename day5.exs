defmodule Day5 do

  def password(door_id) do
    Stream.unfold({door_id, 0}, fn {id, n} -> {next_hash(id, n), {id, n+1}} end)
    |> Stream.filter(&String.starts_with?(&1, "00000"))
    |> Stream.take(8)
    |> Enum.map_join(&String.at(&1, 5))
  end

  defp next_hash(prefix, number), do: :crypto.hash(:md5, prefix <> "#{number}") |> Base.encode16(case: :lower)
end

ExUnit.start

defmodule Day5Test do
  use ExUnit.Case, async: true
  @input "ffykfhsq"

  # test "part 1 example" do
  #   IO.puts "this example takes around 20 seconds to run"
  #   "18f47a30" = Day5.password("abc")
  # end

  test "part 1 input" do
    IO.puts "this example takes around 20 seconds to run"
    password = Day5.password(@input)
    IO.puts "The password for door id #{@input} is #{password}"
  end
end
