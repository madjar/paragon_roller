defmodule ParagonRollerWeb.PageController do
  use ParagonRollerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
