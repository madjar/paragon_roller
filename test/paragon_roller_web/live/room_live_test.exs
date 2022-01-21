defmodule ParagonRollerWeb.RoomLiveTest do
  use ParagonRollerWeb.ConnCase

  import Phoenix.LiveViewTest
  # import ParagonRoller.RoomsFixtures

  # on_exit(fn ->
  #   for pid <- MyAppWeb.Presence.fetchers_pids() do
  #     ref = Process.monitor(pid)
  #     assert_receive {:DOWN, ^ref, _, _, _}, 1000
  #   end
  # end)

  @room_id "awesome-game"

  # @create_attrs %{name: "some name"}
  # @update_attrs %{name: "some updated name"}
  # @invalid_attrs %{name: nil}

  # defp create_room(_) do
  #   room = room_fixture()
  #   %{room: room}
  # end

  test "change the player name", %{conn: conn} do
    {:ok, live, _html} = live(conn, Routes.live_path(conn, ParagonRollerWeb.RoomLive, @room_id))

    assert live
           |> form("#player-form", player: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"

    assert live
           |> form("#player-form", player: %{name: "some name"})
           |> render_submit() =~ "some name"
  end

  test "there is a list of all players", %{conn: conn} do
    {:ok, live1, _html} = live(conn, Routes.live_path(conn, ParagonRollerWeb.RoomLive, @room_id))
    {:ok, live2, _html} = live(conn, Routes.live_path(conn, ParagonRollerWeb.RoomLive, @room_id))

    assert live1
           |> form("#player-form", player: %{name: "player1"})
           |> render_submit() =~ "player1"

    assert live2
           |> form("#player-form", player: %{name: "player2"})
           |> render_submit() =~ "player1"

    assert render(live1) =~ "player2"
  end
end
