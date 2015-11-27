defmodule Relief.Valve do
  def stream(pressure, opts \\ []) do
    flow = Keyword.get(opts, :flow, 1)
    Relief.Valve.Stream.__build__(pressure, flow)
  end

  def example do
    1..20
    |> Stream.map(fn (i) -> "message #{i}" end)
    |> Enum.into(Relief.Valve.stream(10))
    |> Stream.chunk(5)
    |> Enum.to_list
  end

  def runner do
    example()
  end
end
