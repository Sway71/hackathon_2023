defmodule Hackathon2023.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
