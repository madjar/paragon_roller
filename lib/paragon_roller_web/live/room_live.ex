defmodule ParagonRollerWeb.RoomLive do
  use ParagonRollerWeb, :live_view

  alias ParagonRollerWeb.Presence
  alias ParagonRoller.Engine.RoomServer

  import ParagonRollerWeb.DiceHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    topic = "room:#{id}"
    # TODO, autogen, or empty
    player_name = "Madjar"

    RoomServer.start_if_needed(id)
    state = RoomServer.get_state(id)

    if connected?(socket) do
      ParagonRollerWeb.Endpoint.subscribe(topic)

      Presence.track(self(), topic, player_name, %{})
    end

    {:noreply,
     socket
     |> assign(:room_name, id)
     |> assign(:state, state)
     |> assign(:topic, topic)
     |> assign(:player_name, player_name)
     # |> assign(:player_changeset, player_changeset()) # TODO
     |> assign(:player_changeset, nil)
     |> assign(:connected_players, list_connected_players(topic))}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket |> assign(:connected_players, list_connected_players(socket.assigns.topic))}
  end

  defp list_connected_players(topic) do
    Presence.list(topic) |> Map.delete("") |> Map.keys()
  end

  defp player_changeset(attrs \\ %{}) do
    types = %{name: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(attrs, [:name])
    |> Ecto.Changeset.validate_required([:name])
  end

  @impl true
  def handle_event("validate", %{"player" => player_params}, socket) do
    changeset =
      player_changeset(player_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :player_changeset, changeset)}
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    changeset = player_changeset(player_params)

    case Ecto.Changeset.apply_action(changeset, :update) do
      {:ok, data} ->
        {:noreply, socket |> change_name(data.name) |> assign(:player_changeset, nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :player_changeset, changeset)}
    end
  end

  def handle_event("dice_change", %{"roll" => %{"dice" => value}}, socket) do
    RoomServer.set_strife_dicepool(socket.assigns.room_name, value)
    {:noreply, socket}
  end

  defp change_name(socket, new_name) do
    Presence.untrack(self(), socket.assigns.topic, socket.assigns.player_name)
    Presence.track(self(), socket.assigns.topic, new_name, %{})
    assign(socket, :player_name, new_name)
  end

  # def handle_event(name, payload, socket) do
  #   IO.inspect(name)
  #   IO.inspect(payload)
  #   {:noreply, socket}
  # end
end
