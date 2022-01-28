defmodule ParagonRoller.Engine.HeroResult do
  alias __MODULE__
  alias ParagonRoller.Engine.DicePool

  @enforce_keys [:dice, :result]
  defstruct [:dice, :result]

  @type t :: %HeroResult{dice: DicePool.dice_roll(), result: integer()}

  @doc """
  Rolls a dice pool as a hero
  """
  @spec roll(DicePool.t()) :: {:ok, HeroResult.t()}
  def roll(%DicePool{flat: nil} = pool) do
    # TODO validation that the pool is big enough to be rolled
    dice = DicePool.roll(pool)

    {:ok, %HeroResult{dice: dice, result: solve_roll(dice)}}
  end

  @doc """
  Count the dice for a hero

  iex> ParagonRoller.Engine.HeroResult.solve_roll([{5, 6}, {3, 8}, {1, 10}])
  8

  iex> ParagonRoller.Engine.HeroResult.solve_roll([{5, 6}, {3, 8}, {2, 4}])
  10
  """
  def solve_roll(dice) do
    {bonus_dice, non_bonus_dice} = Enum.split_with(dice, fn {_, face} -> face == 4 end)
    base = non_bonus_dice |> Stream.take(2) |> Stream.map(&elem(&1, 0)) |> Enum.sum()
    bonus = bonus_dice |> Stream.take(1) |> Stream.map(&elem(&1, 0)) |> Enum.sum()

    base + bonus
  end
end
