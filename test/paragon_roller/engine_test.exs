defmodule ParagonRoller.EngineTest do
  use ExUnit.Case, async: true

  alias ParagonRoller.Engine.{DicePool}
  doctest ParagonRoller.Engine.DicePool, import: true
  doctest ParagonRoller.Engine.HeroConfig
  doctest ParagonRoller.Engine.HeroResult, import: true
  doctest ParagonRoller.Engine.ContestConfig
  doctest ParagonRoller.Engine.ContestTarget
end
