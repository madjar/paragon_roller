defmodule ParagonRollerWeb.PageControllerTest do
  use ParagonRollerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Paragon Dice Roller"
  end
end
