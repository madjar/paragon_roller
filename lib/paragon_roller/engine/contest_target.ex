defmodule ParagonRoller.Engine.ContestTarget do
  alias __MODULE__
  alias ParagonRoller.Engine.DicePool

  @enforce_keys [:dice, :flat, :result]
  defstruct [:dice, :flat, :result]

  @type t :: %ContestTarget{dice: DicePool.dice_roll(), flat: integer(), result: integer()}

  @doc """
  Roll a dice pool as the strife
  """
  @spec roll(DicePool.t()) :: {:ok, ContestTarget.t()}
  def roll(%DicePool{flat: flat} = pool) when is_integer(flat) do
    # TODO validation that the pool is big enough to be rolled
    dice = DicePool.roll(pool)
    result = elem(Enum.max(dice), 0) + flat
    {:ok, %ContestTarget{dice: dice, flat: flat, result: result}}
  end
end
