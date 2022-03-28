defmodule ParagonRoller.Engine.RoomServer do
  use GenServer
  require Logger

  alias ParagonRoller.Engine.State
  alias ParagonRoller.Engine.DicePool

  # Client
  def child_spec(opts) do
    name = Keyword.get(opts, :name)

    %{id: "#{__MODULE__}_#{name}", start: {__MODULE__, :start_link, [name]}}
  end

  def start_link(name) do
    case GenServer.start_link(__MODULE__, nil, name: via_tuple(name)) do
      {:ok, pid} ->
        Logger.info("Started RoomServer #{inspect(name)} at #{inspect(pid)}")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info(
          "Already started RoomServer #{inspect(name)} at #{inspect(pid)}, returning :ignore"
        )

        :ignore
    end
  end

  def start_if_needed(name) do
    Horde.DynamicSupervisor.start_child(
      ParagonRoller.DistributedSupervisor,
      {__MODULE__, [name: name]}
    )
  end

  def get_state(room_name) do
    GenServer.call(via_tuple(room_name), :get_state)
  end

  def set_strife_dicepool(room_name, pool_text) do
    GenServer.cast(via_tuple(room_name), {:set_strife_dicepool, pool_text})
  end

  # Server

  @impl true
  def init(nil) do
    {:ok, %{room_state: State.new()}}
  end

  @impl true
  def handle_call(:get_state, _, %{room_state: room_state} = state) do
    {:reply, room_state, state}
  end

  @impl true
  def handle_cast({:set_strife_dicepool, pool_text}, state) do
    case DicePool.parse(pool_text) do
      {:ok, dice_pool} ->
        {:noreply, put_in(state.room_state.contest_config.strife_dice_pool, dice_pool)}

      # TODO broadcast new state

      {:error, _} ->
        {:noreply, state}
    end
  end

  #  def broadcast_state()

  def via_tuple(room_name), do: {:via, Horde.Registry, {ParagonRoller.GameRegistry, room_name}}
end
