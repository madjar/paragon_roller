defmodule ParagonRoller.Engine.DicePool do
  alias __MODULE__

  @enforce_keys [:dice]
  defstruct [:dice, :flat]

  @type t :: %DicePool{
          dice: [{count :: integer(), faces :: integer()}],
          flat: integer() | nil
        }

  def parse(str) do
    with charlist <- String.to_charlist(str),
         {:ok, tokens, _} <- :dice_lexer.string(charlist),
         {:ok, list} <- :dice_parser.parse(tokens) do
      {:ok, %DicePool{dice: list}}
    else
      {:error, {1, :dice_lexer, reason}, 1} ->
        {:error, {:tokenizing_failed, reason}}

      {:error, {_, :dice_parser, reason}} ->
        {:error, {:token_parsing_failed, reason}}
    end
  end
end
