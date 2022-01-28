defmodule ParagonRoller.Engine.ContestConfig do
  alias __MODULE__
  alias ParagonRoller.Engine.DicePool

  @enforce_keys [:strife_dice_pool]
  defstruct strife_dice_pool: nil, tag: [], description: ""

  @type t :: %ContestConfig{
          strife_dice_pool: DicePool.t(),
          tag: [],
          description: String.t()
        }

  def new do
    %ContestConfig{strife_dice_pool: DicePool.new()}
  end
end
