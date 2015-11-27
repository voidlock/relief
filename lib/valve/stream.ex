defmodule Relief.Valve.Stream do

  defstruct valve: nil, flow: 1

  @type t :: %__MODULE__{}

  def __build__(pressure, flow) do
    {:ok, pid} = Relief.Valve.Server.start_link(pressure)
    %Relief.Valve.Stream{flow: flow, valve: pid}
  end

  defimpl Collectable do

    def into(%{valve: pid} = stream) do
      {:ok, into(pid, stream)}
    end

    defp into(pid, stream) do
      fn
        (:ok, {:cont, x}) ->
          Relief.Valve.Server.intake(pid, x)
        (:ok, :done) ->
          stream
        (:ok, :halt) ->
          :ok
      end
    end
  end

  defimpl Enumerable do
    def reduce(%{valve: pid, flow: flow}, acc, fun) do
      start_fn = fn () -> :ok end
      next_fn = fn (:ok) ->
        case Relief.Valve.Server.outlet(pid, flow) do
          {[], _count, _drop} ->
            {:halt, :ok}
          {items, _count, drop} ->
            {[{items, drop}], :ok}
        end
      end
      after_fn = fn (:ok) -> :ok end

      Stream.resource(start_fn, next_fn, after_fn).(acc, fun)
    end

    def count(%{valve: pid}) do
      Relief.Valve.Server.count(pid)
    end

    def member?(_stream, _term) do
      {:error, __MODULE__}
    end
  end
end
