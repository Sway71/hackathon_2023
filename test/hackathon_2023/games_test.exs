defmodule Hackathon2023.GamesTest do
  use Hackathon2023.DataCase

  alias Hackathon2023.Games

  describe "battles" do
    alias Hackathon2023.Games.Battle

    import Hackathon2023.GamesFixtures

    @invalid_attrs %{name: nil}

    test "list_battles/0 returns all battles" do
      battle = battle_fixture()
      assert Games.list_battles() == [battle]
    end

    test "get_battle!/1 returns the battle with given id" do
      battle = battle_fixture()
      assert Games.get_battle!(battle.id) == battle
    end

    test "create_battle/1 with valid data creates a battle" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Battle{} = battle} = Games.create_battle(valid_attrs)
      assert battle.name == "some name"
    end

    test "create_battle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_battle(@invalid_attrs)
    end

    test "update_battle/2 with valid data updates the battle" do
      battle = battle_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Battle{} = battle} = Games.update_battle(battle, update_attrs)
      assert battle.name == "some updated name"
    end

    test "update_battle/2 with invalid data returns error changeset" do
      battle = battle_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_battle(battle, @invalid_attrs)
      assert battle == Games.get_battle!(battle.id)
    end

    test "delete_battle/1 deletes the battle" do
      battle = battle_fixture()
      assert {:ok, %Battle{}} = Games.delete_battle(battle)
      assert_raise Ecto.NoResultsError, fn -> Games.get_battle!(battle.id) end
    end

    test "change_battle/1 returns a battle changeset" do
      battle = battle_fixture()
      assert %Ecto.Changeset{} = Games.change_battle(battle)
    end
  end
end
