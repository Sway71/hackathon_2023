defmodule Hackathon2023Web.GameController do
  use Hackathon2023Web, :controller
  alias Hackathon2023.Games

  require Logger

  directions = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]

  def clean_hget_all_data(character_data) do
    for [trait_key, trait_value] <- Enum.chunk_every(character_data, 2), reduce: %{} do
      acc ->
        Map.put(acc, trait_key, trait_value)
    end
  end

  def show(conn, %{"id" => game_id}) do
    [this_player_token] = get_req_header(conn, "player-token")
    game = Games.get_battle!(game_id)

    commander = cond do
      game.player_1_token == this_player_token -> "player_1"
      game.player_2_token == this_player_token -> "player_2"
      true -> "spectator"
    end

    game_ref = "battle:#{game.id}"
    {
      :ok,
      [
        active_slot,
        phase,
        character_1_data,
        character_2_data,
        layout_data
      ]
    } = Redix.pipeline(:redix, [
      ["GET", "#{game_ref}:active_slot"],
      ["GET", "#{game_ref}:phase"],
      ["HGETALL", "#{game_ref}:character:1"],
      ["HGETALL", "#{game_ref}:character:2"],
      ["HGETALL", "#{game_ref}:layout"]
    ])

    character_1 = clean_hget_all_data(character_1_data)
    character_2 = clean_hget_all_data(character_2_data)
    layout = clean_hget_all_data(layout_data)

    # TODO: use Elixir to cleanup that Redis response from HGETALL
    json(conn, %{
      id: game.id,
      gameName: game.name,
      gameSize: game.game_size,
      gameUrl: game.game_url,
      commander: commander,
      activeSlot: active_slot,
      phase: phase,
      character1: character_1,
      character2: character_2,
      layout: layout
    })
  end

  def create(conn, %{"name" => game_name, "size" => game_size}) do
    player_1_token = UUID.uuid4()
    player_2_token = UUID.uuid4()

    # Commence creating game in Redis
    # - character id list?
    # - characters
    #   - commander [player_1 or player_2]
    #   - facing
    #   - [FOR_LATER]: id, class, speed, activeCounter
    # - gameboard
    #   - dimensions (height, width)
    #   - layout
    #   - name?

    # TODO: need to check for uniqueness on the game_name
    game_url = "localhost:5173/battlefield/#{game_name}"
    {:ok, game} = Games.create_battle(%{
      name: game_name,
      game_url: game_url,
      game_size: game_size,
      player_1_token: player_1_token,
      player_2_token: player_2_token
    })

    game_ref = "battle:#{game.id}"
    {:ok, _answer} = Redix.pipeline(:redix, [
      ["SET", "#{game_ref}:player_1_token", player_1_token],
      ["SET", "#{game_ref}:player_2_token", player_2_token],
      ["SET", "#{game_ref}:active_slot", "1"],
      ["SET", "#{game_ref}:phase", "START"],
      ["HSET", "#{game_ref}:character:1", "name", "Bob", "commander", "player_1", "hp", "50", "x", "0", "y", "3"],
      ["HSET", "#{game_ref}:character:2", "name", "George", "commander", "player_2", "hp", "50", "x", "7", "y", "4"],
      ["HSET", "#{game_ref}:layout", "4_4", "obstacle_1", "0_3", "character_1", "7_4", "character_2"]
    ])

    json(conn, %{
      "gameId" => game.id,
      "gameName" => game_name,
      "gameUrl" => game_url,
      "player1Token" => player_1_token,
      "player2Token" => player_2_token
    })
  end

  def edit(conn, %{"id" => game_id}) do
    json(conn, %{message: "Not implemented yet!", game_id: game_id})
  end
end
