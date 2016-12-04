defmodule Demo.Recursion do
  use Bitwise

  def compound_loop(first_count, second_count, third_count, fourth_count, fifth_count, number_tuple) do
    for a <- 0..first_count, b <- (a+1)..second_count, c <- (b+1)..third_count, d <- (c+1)..fourth_count, e <- (d+1)..fifth_count do
      elem(number_tuple, a) ||| elem(number_tuple, b) ||| elem(number_tuple, c) ||| elem(number_tuple, d) ||| elem(number_tuple, e)
    end
  end

  def test_recursion() do
    new_list = 1..48 |> Enum.to_list |> List.to_tuple
    {time, res} = :timer.tc(fn -> compound_loop(43, 44, 45, 46, 47, new_list) end)
    IO.inspect res
    IO.puts "length: #{length(res)}"
    time / 1000
  end
end

IO.puts Demo.Recursion.test_recursion
