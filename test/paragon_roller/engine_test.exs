defmodule ParagonRoller.EngineTest do
  use ExUnit.Case, async: true
  doctest ParagonRoller.Engine.DicePool
  doctest ParagonRoller.Engine.HeroConfig
  doctest ParagonRoller.Engine.HeroResult
  doctest ParagonRoller.Engine.ContestConfig
  doctest ParagonRoller.Engine.ContestTarget
end
