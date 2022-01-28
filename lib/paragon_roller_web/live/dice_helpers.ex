defmodule ParagonRollerWeb.DiceHelpers do
  # import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def roll_result(assigns) do
    ~H"""
    <p><%= render_result(@dice) %></p>
    """
  end

  defp render_result(dice) do
    (dice || [])
    |> Stream.map(fn {result, dice} -> "#{result}/#{dice}" end)
    |> Enum.join(" ~ ")
  end
end
