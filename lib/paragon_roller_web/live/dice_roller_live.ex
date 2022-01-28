defmodule ParagonRollerWeb.DiceRollerLive do
  use ParagonRollerWeb, :live_view
  alias ParagonRoller.Engine.DicePool

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, dice_pool: DicePool.new(), result: "")}
  end

  def dice_pool(assigns) do
    ~H"""
    <form phx-change="dice_change", phx-submit="roll">
    <%= text_input :roll, :dice, value: DicePool.render(@dice_pool) %>
    </form>
    <p><%= DicePool.render(@dice_pool) %></p>
    """
  end

  @impl true

  def handle_event("dice_change", %{"roll" => %{"dice" => value}}, socket) do
    case DicePool.parse(value) do
      {:ok, dice_pool} -> {:noreply, assign(socket, :dice_pool, dice_pool)}
      {:error, _} -> {:noreply, socket}
    end
  end

  def handle_event("roll", _value, socket) do
    result =
      socket.assigns.dice_pool
      |> DicePool.roll()
      |> Stream.map(fn {result, dice} -> "#{result}/#{dice}" end)
      |> Enum.join(", ")

    {:noreply, assign(socket, :result, result)}
  end
end

# for={@player_changeset}
# as="player"
# id="player-form"
# phx-change="validate"

# <div>
# <%= submit "Save", phx_disable_with: "Saving..." %>
# </div>
# <input type="text">
#   <%= DicePool.render(@dice_pool) %>
# </input>
