defmodule RefrigeratorGen do
  use GenServer

  ### Interface

  def start() do
    GenServer.start(__MODULE__, %{}, name: __MODULE__)
  end

  def add(item, quantity) do
    GenServer.cast(__MODULE__, {:add, item, quantity})
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  # TODO: add the take function

  ### Internal

  def init(refrigerator) do
    {:ok, refrigerator}
  end

  def handle_cast({:add, item, quantity}, refrigerator) do
    {:noreply,
     Map.update(refrigerator, item, quantity, fn current_quantity ->
       current_quantity + quantity
     end)}
  end

  # TODO: if the item is not present, it will now have 0 as value. How can we avoid that?
  def handle_cast({:take, item, quantity}, refrigerator) do
    {:noreply,
     Map.update(refrigerator, item, 0, fn
       current_quantity when current_quantity < quantity -> 0
       current_quantity -> current_quantity - quantity
     end)}
  end

  def handle_call(:status, _from, refrigerator) do
    {:reply, refrigerator, refrigerator}
  end
end
