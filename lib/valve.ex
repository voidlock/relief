defmodule Relief.Valve do
  def stream(pressure, opts \\ []) do
    flow = Keyword.get(opts, :flow, 1)
    Relief.Valve.Stream.__build__(pressure, flow)
  end
end
