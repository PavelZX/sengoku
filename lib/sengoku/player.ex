defmodule Sengoku.Player do
  defstruct unplaced_units: 0, active: true, ai: true

  def new(atts \\ %{}) do
    struct(__MODULE__, atts)
  end

  def initialize_state(state) do
    Map.put(state, :players, %{
      1 => new(),
      2 => new(),
      3 => new(),
      4 => new()
    })
  end

  def update_attributes(state, player_id, %{} = new_atts) do
    update_in(state, [:players, player_id], fn(player) ->
      Map.merge(player, new_atts)
    end)
  end

  def use_reinforcement(state, player_id) do
    update(state, player_id, :unplaced_units, &(&1 - 1))
  end

  def grant_reinforcements(state, player_id, count) do
    update(state, player_id, :unplaced_units, &(&1 + count))
  end

  def deactivate(state, player_id) do
    state
    |> update_attributes(player_id, %{active: false, unplaced_units: 0})
  end

  def ai_ids(state) do
    state
    |> filter_ids(&(&1.ai))
  end

  def active_ids(state) do
    state
    |> filter_ids(&(&1.active))
  end

  defp update(state, player_id, key, func) do
    update_in(state, [:players, player_id], fn(player) ->
      Map.update!(player, key, func)
    end)
  end

  defp filter_ids(state, func) do
    state.players
    |> Enum.filter(fn({_id, player}) -> func.(player) end)
    |> Enum.into(%{})
    |> Map.keys
  end
end
