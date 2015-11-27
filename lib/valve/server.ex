defmodule Relief.Valve.Server do
  use GenServer

  def start_link(size, opts \\ []) do
    GenServer.start_link(__MODULE__, size, opts)
  end

  def intake(valve, term) do
    GenServer.cast(valve, {:intake, term})
  end

  def outlet(valve, limit) do
    GenServer.call(valve, {:outlet, limit})
  end

  def count(valve) do
    GenServer.call(valve, :count)
  end

  def shutdown(valve) do
    GenServer.call(valve, :shutdown)
  end

  def init(max) do
    {:ok, {:queue.new(), max, 0, 0}}
  end

  def handle_call(:inspect, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:count, _from, {_queue, _max, size, _drop}=state) do
    {:reply, size, state}
  end

  def handle_call(:shutdown, _from, state) do
    {:stop, :shutdown, :ok, state}
  end

  def handle_call({:outlet, limit}, _from, {queue, max, size, drop}) when limit > 0 do
    {removed, count, queue2} = queue_out(queue, limit)
    {:reply, {removed, count, drop}, {queue2, max, size-count, 0}}
  end

  def handle_cast({:intake, item}, {queue, max, max, drop}) do
    {:noreply, {drop_in(queue, item), max, max, drop+1}}
  end

  def handle_cast({:intake, item}, {queue, max, size, drop}) do
    {:noreply, {queue_in(queue, item), max, size+1, drop}}
  end

  defp drop_in(queue, item) do
    queue |> :queue.drop |> queue_in(item)
  end

  defp queue_in(queue, item) do
    :queue.in(item, queue)
  end

  defp queue_out(queue, limit) do
    queue_out(queue, limit, [], 0)
  end

  defp queue_out(queue, limit, items, limit) do
    {:lists.reverse(items), limit, queue}
  end

  defp queue_out(queue, limit, items, count) do
    case :queue.out(queue) do
      {:empty, queue} ->
        {:lists.reverse(items), count, queue}
      {{:value, item}, queue} ->
        queue_out(queue, limit, [item|items], count+1)
    end
  end
end
