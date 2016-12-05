defmodule Day5 do

  def password_in_order(door_id) do
    relevant_hashes(door_id)
    |> Stream.take(8)
    |> Enum.map_join(&elem(&1, 0))
  end

  def password_encoded_order(door_id) do
    relevant_hashes(door_id)
    |> Stream.reject(fn {pos, _} -> pos > "7" end)
    |> Enum.reduce_while(%{}, fn {pos, char}, map ->
      map = Map.put_new(map, pos, char)
      if length(Map.keys(map)) == 8, do: {:halt, Enum.sort(map)},
      else: {:cont, map}
    end)
    |> Enum.map_join(&elem(&1, 1))
  end

  defp relevant_hashes(door_id) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn n -> :crypto.hash(:md5, [door_id, "#{n}"]) |> Base.encode16(case: :lower) end)
    |> Stream.filter_map(&String.starts_with?(&1, "00000"), &{String.at(&1, 5), String.at(&1, 6)})
  end
end

ExUnit.start()

defmodule Day5Test do
  use ExUnit.Case, async: true
  @moduletag timeout: 120000 #2 minutes
  @input "ffykfhsq"

  test "part 1 example" do
    IO.puts "this example takes around 20 seconds to run"
    assert "18f47a30" = Day5.password_in_order("abc")
  end

  test "part 1 input" do
    IO.puts "this example takes around 20 seconds to run"
    password = Day5.password_in_order(@input)
    IO.puts "The in order password for door id #{@input} is #{password}"
    assert "c6697b55" = password
  end

  test "part 2 example" do
    IO.puts "patience, this one is closer to 1 minute"
    assert "05ace8e3" = Day5.password_encoded_order("abc")
  end

  test "part 2 input" do
    IO.puts "patience, this one is closer to 1.5 minute"
    password = Day5.password_encoded_order(@input)
    IO.puts "The encoded order password for door id #{@input} is #{password}"
    assert "8c35d1ab" = password
  end
end
