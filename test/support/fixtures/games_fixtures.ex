defmodule Hackathon2023.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hackathon2023.Games` context.
  """

  @doc """
  Generate a battle.
  """
  def battle_fixture(attrs \\ %{}) do
    {:ok, battle} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Hackathon2023.Games.create_battle()

    battle
  end
end
