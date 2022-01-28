defmodule ParagonRoller.Engine.HeroConfig do
  alias __MODULE__
  alias ParagonRoller.Engine.DicePool

  defstruct dice_pool: nil, supporting: nil

  @type t :: %HeroConfig{
          dice_pool: DicePool.t(),
          supporting: String.t() | nil
        }

  def new do
    %HeroConfig{dice_pool: DicePool.new()}
  end
end
