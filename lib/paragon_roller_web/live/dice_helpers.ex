defmodule ParagonRollerWeb.DiceHelpers do
  # import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  use Phoenix.HTML

  alias ParagonRoller.Engine.DicePool

  def dice_pool(assigns) do
    ~H"""
    <p><%= ParagonRoller.Engine.DicePool.render(@dice_pool) %></p>
    """
  end

  def dice_pool_input(assigns) do
    ~H"""
    <form phx-change={@change}, phx-submit={@submit}>
    <%= text_input :roll, :dice, value: DicePool.render(@dice_pool) %>
    </form>
    """
  end

  def roll_result(assigns) do
    ~H"""
    <p><%= render_result(@dice) %></p>
    """
  end

  def fancy_roll_result(assigns) do
    # TODO use the proper dice
    # TODO make the icon nice
    ~H"""
    <div style="font-size: 2em;">
    <%= for {{result, die}, index} <- Enum.with_index(@dice || []) do %>
      <%= if index != 0 do %>
      ~
      <% end %>
      <%= "#{result}" %> <span style="width: 3rem; height: 3rem;"><.dice6/></span>
    <% end %>
    </div>
    <p><%= render_result(@dice) %></p>
    """
  end

  defp render_result(dice) do
    (dice || [])
    |> Stream.map(fn {result, dice} -> "#{result}/#{dice}" end)
    |> Enum.join(" ~ ")
  end

  def dice6(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      style="height: 1em; width: 1em;"
    >
      <path d="M0 0h512v512H0z" fill="#000000" fill-opacity="1"></path>
      <g class="" transform="translate(0,0)" style="">
        <path
          d="M255.703 44.764c-6.176 0-12.353 1.384-17.137 4.152l-152.752 88.36c-9.57 5.535-9.57 14.29 0 19.826l152.752 88.359c9.57 5.536 24.703 5.536 34.272 0l152.754-88.36c9.57-5.534 9.57-14.289 0-19.824L272.838 48.916c-4.785-2.77-10.96-4.152-17.135-4.152zM238.695 87.27l22.838 14.273c-6.747 1.007-12.586 2.28-17.515 3.818-4.985 1.504-9.272 3.334-12.864 5.489-7.721 4.633-11.09 9.897-10.105 15.793.93 5.86 6.223 12.247 15.875 19.16.26-3.467 1.457-6.652 3.59-9.553 2.077-2.936 5.159-5.629 9.244-8.08 10.28-6.168 22.259-8.83 35.935-7.98 13.722.821 26.568 4.973 38.537 12.455 13.239 8.274 20.334 17.024 21.284 26.251.894 9.194-4.584 17.346-16.436 24.458-13.064 7.838-28.593 10.533-46.588 8.085-18.004-2.508-36.964-9.986-56.877-22.431-20.41-12.756-32.258-25.276-35.547-37.56-3.299-12.347 2.348-22.895 16.938-31.65 4.624-2.774 9.554-5.192 14.79-7.253 5.238-2.061 10.871-3.82 16.901-5.275zm38.678 53.23c-4.169-.007-7.972 1.02-11.406 3.08-4.534 2.72-6.125 5.906-4.774 9.555 1.341 3.587 5.624 7.64 12.85 12.156 7.226 4.516 13.78 7.237 19.666 8.166 5.875.867 11.081-.059 15.615-2.78 4.58-2.747 6.198-5.915 4.858-9.503-1.351-3.65-5.64-7.732-12.866-12.248-7.226-4.516-13.777-7.207-19.652-8.074a27.826 27.826 0 0 0-4.291-.352zm158.494 33.314c-1.938.074-4.218.858-6.955 2.413l-146.935 84.847c-9.57 5.527-17.14 18.638-17.14 29.69v157.699c0 11.05 7.57 15.419 17.14 9.89l146.937-84.843c9.57-5.527 17.137-18.636 17.137-29.688v-157.7c-2.497-8.048-5.23-12.495-10.184-12.308zm-359.763.48c-6.227 0-10.033 5.325-10.155 11.825v157.697c0 11.052 7.57 24.163 17.14 29.69l146.93 84.848c9.57 5.526 17.141 1.156 17.141-9.895v-157.7c0-11.051-7.57-24.159-17.14-29.687L83.09 176.225c-2.567-1.338-4.911-1.93-6.986-1.93zm40.095 52.226l68.114 40.869v25.287l-46.262-27.758v20.64a43.279 43.279 0 0 1 6.262 2.151c2.135.864 4.341 1.98 6.619 3.346 12.953 7.772 23.037 17.902 30.25 30.39 7.212 12.43 10.818 25.912 10.818 40.448 0 14.416-3.938 23.342-11.814 26.777-7.83 3.464-18.72 1.01-32.67-7.36-6.026-3.615-12.005-7.948-17.936-12.996-5.884-4.96-11.744-10.68-17.58-17.16v-27.076c5.789 7.643 11.27 14.06 16.441 19.248 5.22 5.217 10.13 9.205 14.733 11.967 6.643 3.986 11.862 5.092 15.658 3.318 3.843-1.804 5.766-6.19 5.766-13.16 0-7.03-1.923-13.723-5.766-20.08-3.796-6.328-9.015-11.485-15.658-15.47a56.585 56.585 0 0 0-12.598-5.594c-4.46-1.426-9.252-2.335-14.377-2.729V226.52zm270.047 5.732v85.809L400 309.809v25.414l-13.754 8.252v24.777l-23.502 14.102v-24.778L320 383.223v-30.06l38.611-104.331 27.635-16.58zm-23.502 42.978l-27.248 73.28 27.248-16.348V275.23z"
          fill="#fff"
          fill-opacity="1"
        ></path>
      </g>
    </svg>
    """
  end
end
