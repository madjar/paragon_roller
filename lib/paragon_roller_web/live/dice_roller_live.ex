defmodule ParagonRollerWeb.DiceRollerLive do
  use ParagonRollerWeb, :live_view
  alias ParagonRoller.Engine.DicePool

  import ParagonRollerWeb.DiceHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       dice_pool: %DicePool{dice: %{6 => 1, 10 => 2}},
       # TODO remove
       result: [{1, 6}, {2, 12}]
     )}
  end

  def dice_pool_input(assigns) do
    ~H"""
    <form phx-change="dice_change", phx-submit="roll">
    <%= text_input :roll, :dice, value: DicePool.render(@dice_pool) %>
    </form>
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
