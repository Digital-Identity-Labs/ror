#!/usr/bin/env elixir
Mix.install([{:ror, ">= 0.1.0"}])

for page <- 1..5 do
  IO.puts "\nPage #{page}:"
  ROR.list!(page: page)
  |> Enum.each(fn o -> IO.puts "  #{o.id} | #{List.first(o.names)} | #{o.admin}" end)
end
