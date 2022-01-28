defmodule ParagonRoller.Engine.State do
  alias __MODULE__
  alias ParagonRoller.Engine

  @enforce_keys [:contest_config, :hero_configs]
  defstruct [:contest_config, :hero_configs, :contest_result, :hero_results]

  @type t :: %State{
          contest_config: Engine.ContestConfig.t(),
          hero_configs: %{String.t() => Engine.HeroConfig.t()},
          contest_result: Engine.ContestTarget.t() | nil,
          hero_results: %{String.t() => Engine.HeroResult.t()} | nil
        }

  def new do
    %State{
      contest_config: Engine.ContestConfig.new(),
      hero_configs: %{},
      contest_result: nil,
      hero_results: nil
    }
  end
end
