defmodule Hackathon2023.Repo.Migrations.CreateBattles do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :name, :string
      add :player_1, references(:players)
      add :player_2, references(:players)

      timestamps()
    end
  end
end
