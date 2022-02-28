defmodule ParagonRoller.Engine.RoomServer do
  use GenServer
  require Logger

  alias ParagonRoller.Engine.State

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

  @impl true
  def init(nil) do
    {:ok, State.new()}
  end

  def via_tuple(game_code), do: {:via, Horde.Registry, {ParagonRoller.GameRegistry, game_code}}
end
