defmodule Hackathon2023Web.GameUtils.DataUtils do
  def clean_hget_all_data(character_data) do
    for [trait_key, trait_value] <- Enum.chunk_every(character_data, 2), reduce: %{} do
      acc ->
        Map.put(acc, trait_key, trait_value)
    end
  end
end
