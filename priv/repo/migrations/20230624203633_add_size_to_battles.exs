defmodule Hackathon2023.Repo.Migrations.AddSizeToBattles do
  use Ecto.Migration

  def change do
    alter table(:battles) do
      add :game_size, :int
    end
  end
end
