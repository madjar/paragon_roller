defmodule ParagonRoller.Engine.DicePool do
  alias __MODULE__

  @enforce_keys [:dice]
  defstruct [:dice, :flat]

  @type t :: %DicePool{
          dice: %{(count :: integer()) => faces :: integer()},
          flat: integer() | nil
        }

  @type dice_roll :: [{integer(), integer()}]

  @known_dice [4, 6, 8, 10, 12, 20]

  @spec new :: DicePool.t()
  def new do
    %DicePool{dice: %{}}
  end

  @doc """
  Parse a string representation of a dice pool.

  ## Examples

        iex> parse("1d6, 1d6, 2d12")
        {:ok, %DicePool{dice: %{6 => 2, 12 => 2}, flat: nil}}

  """
  @spec parse(binary) ::
          {:error, {:token_parsing_failed, any} | {:tokenizing_failed, any}}
          | {:ok, ParagonRoller.Engine.DicePool.t()}
  def parse(str) do
    with {:ok, list} <- parse_raw(str) do
      dice_map =
        list
        |> Enum.reduce(%{}, fn {count, dice}, acc ->
          Map.update(acc, dice, count, &(&1 + count))
        end)

      # The parser treats flat modifiers (+4) as 1-faced dice, we split it here
      # Flat modifiers are however disabled in the parser
      #        {flat, dice_map} = dice_map |> Map.pop(1)
      flat = nil

      {validated_dice_map, bad_map} = Map.split(dice_map, @known_dice)

      if bad_map == %{} do
        {:ok, %DicePool{dice: validated_dice_map, flat: flat}}
      else
        {:error, {:unknown_dice_size, bad_map |> Map.keys() |> Enum.map(&Integer.to_string/1)}}
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

  @spec roll(DicePool.t()) :: dice_roll()
  def roll(%DicePool{dice: dice}) do
    flattened_dice =
      Enum.flat_map(dice, fn {face, count} ->
        List.duplicate(face, count)
      end)

    flattened_dice
    |> Enum.map(fn face -> {:rand.uniform(face), face} end)
    |> Enum.sort(:desc)
  end

  @doc """
  Render a dice pool to a nice string

  iex> render(%DicePool{dice: %{6 => 2, 12 => 2}})
  "2d6, 2d12"
  """
  @spec render(DicePool.t()) :: String.t()
  def render(%DicePool{dice: dice, flat: nil}) do
    dice
    |> Stream.map(fn {face, count} -> "#{count}d#{face}" end)
    |> Enum.join(", ")
  end
end
