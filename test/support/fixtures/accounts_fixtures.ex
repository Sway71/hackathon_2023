defmodule Hackathon2023.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hackathon2023.Accounts` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> Hackathon2023.Accounts.create_player()

    player
  end
end
