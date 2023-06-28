defmodule Hackathon2023.Repo.Migrations.FixGameSchema do
  use Ecto.Migration

  def change do
    alter table(:battles) do
      add :game_url, :text
      add :player_1_token, :text
      add :player_2_token, :text
      remove :player_1
      remove :player_2
    end
  end
end
