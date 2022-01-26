defmodule ParagonRoller.Engine.DicePool do
  alias __MODULE__

  @enforce_keys [:dice]
  defstruct [:dice, :flat]

  @type t :: %DicePool{
          dice: %{(count :: integer()) => faces :: integer()},
          flat: integer() | nil
        }

  @known_dice [4, 6, 8, 10, 12, 20]

  @doc """
  Parse a string representation of a dice pool.

  ## Examples

        iex> ParagonRoller.Engine.DicePool.parse("1d6, 1d6, 2d12, 5")
        {:ok, %ParagonRoller.Engine.DicePool{dice: %{6 => 2, 12 => 2}, flat: 5}}

  """
  @spec parse(binary) ::
          {:error, {:token_parsing_failed, any} | {:tokenizing_failed, any}}
          | {:ok, ParagonRoller.Engine.DicePool.t()}
  def parse(str) do
    with {:ok, list} <- parse_raw(str) do
      {flat, dice_map} =
        list
        |> Enum.reduce(%{}, fn {count, dice}, acc ->
          Map.update(acc, dice, count, &(&1 + count))
        end)
        |> Map.pop(1)

      {validated_dice_map, bad_map} = Map.split(dice_map, @known_dice)

      if bad_map == %{} do
        {:ok, %DicePool{dice: validated_dice_map, flat: flat}}
      else
        {:error, :unknown_dice_size, bad_map |> Map.keys() |> Enum.map(&Integer.to_string/1)}
      end
    end
  end

  defp parse_raw(str) do
    with charlist <- String.to_charlist(str),
         {:ok, tokens, _} <- :dice_lexer.string(charlist),
         {:ok, list} <- :dice_parser.parse(tokens) do
      {:ok, list}
    else
      {:error, {1, :dice_lexer, reason}, 1} ->
        {:error, {:tokenizing_failed, reason}}

      {:error, {_, :dice_parser, reason}} ->
        {:error, {:token_parsing_failed, reason}}
    end
  end

  def roll(%DicePool{dice: dice, flat: flat}) do
    flattened_dice =
      Enum.flat_map(dice, fn {face, count} ->
        List.duplicate(face, count)
      end)

    from_dice = Enum.map(flattened_dice, fn face -> {:rand.uniform(face), face} end)

    from_dice ++ [{flat, 1}]
  end
end
