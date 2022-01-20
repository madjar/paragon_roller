defmodule ParagonRoller.Repo do
  use Ecto.Repo,
    otp_app: :paragon_roller,
    adapter: Ecto.Adapters.Postgres
end
