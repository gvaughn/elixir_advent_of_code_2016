defmodule Day5 do

  def password_in_order(door_id) do
    door_id
    |> relevant_hashes
    |> Stream.take(8)
    |> Enum.map_join(&String.at(&1, 5))
  end

  def password_encoded_order(door_id) do
    door_id
    |> relevant_hashes
    |> Stream.reject(fn h -> String.at(h, 5) > "7" end)
    |> Enum.reduce_while(%{}, fn hash, map ->
      map = Map.put_new(map, String.at(hash, 5), String.at(hash, 6))
      action = if length(Map.keys(map)) == 8, do: :halt, else: :cont
      {action, map}
    end)
    |> Map.values
    |> Enum.join
  end

  defp relevant_hashes(door_id) do
    Stream.unfold({door_id, 0}, fn {id, n} -> {next_hash(id, n), {id, n+1}} end)
    |> Stream.filter(&String.starts_with?(&1, "00000"))
  end

  defp next_hash(prefix, number), do: :crypto.hash(:md5, prefix <> "#{number}") |> Base.encode16(case: :lower)
end

ExUnit.start()

defmodule Day5Test do
  use ExUnit.Case, async: true
  @moduletag timeout: 120000 #2 minutes
  @input "ffykfhsq"

  # test "part 1 example" do
  #   IO.puts "this example takes around 20 seconds to run"
  #   assert "18f47a30" = Day5.password_in_order("abc")
  # end

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

  # test "part 2 input" do
  #   IO.puts "patience, this one is closer to 1.5 minute"
  #   password = Day5.password_encoded_order(@input)
  #   IO.puts "The encoded order password for door id #{@input} is #{password}"
  #   assert "8c35d1ab" = password
  # end
end
