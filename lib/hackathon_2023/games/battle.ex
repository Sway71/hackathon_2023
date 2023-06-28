defmodule Hackathon2023.Games.Battle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "battles" do
    field :name, :string
    field :game_url, :string
    field :game_size, :integer
    field :player_1_token, :string
    field :player_2_token, :string
    # belongs_to :player_1, Hackathon2023.Accounts.Player
    # belongs_to :player_2, Hackathon2023.Accounts.Player

    timestamps()
  end

  @doc false
  def changeset(battle, attrs) do
    battle
    |> cast(attrs, [:name, :game_url, :game_size, :player_1_token, :player_2_token])
    |> validate_required([:name, :game_url, :game_size, :player_1_token, :player_2_token])
  end
end
