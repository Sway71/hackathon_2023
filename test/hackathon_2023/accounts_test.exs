defmodule Hackathon2023.AccountsTest do
  use Hackathon2023.DataCase

  alias Hackathon2023.Accounts

  describe "players" do
    alias Hackathon2023.Accounts.Player

    import Hackathon2023.AccountsFixtures

    @invalid_attrs %{email: nil, name: nil}

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Accounts.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Accounts.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{email: "some email", name: "some name"}

      assert {:ok, %Player{} = player} = Accounts.create_player(valid_attrs)
      assert player.email == "some email"
      assert player.name == "some name"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name"}

      assert {:ok, %Player{} = player} = Accounts.update_player(player, update_attrs)
      assert player.email == "some updated email"
      assert player.name == "some updated name"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_player(player, @invalid_attrs)
      assert player == Accounts.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Accounts.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Accounts.change_player(player)
    end
  end
end
