defmodule Hackathon2023Web.ChatChannel do
  use Hackathon2023Web, :channel

  alias Hackathon2023.Chats
  alias Hackathon2023Web.GameUtils.GameMovement
  alias Hackathon2023Web.GameUtils.DataUtils
  require Logger

  @impl true
  def join("chat:" <> _room, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    "chat:" <> room = socket.topic
    payload = Map.merge(payload, %{"room" => room})
    Chats.create_message(payload)
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in(
    "check_movement",
    %{
      "battleId" => battle_id,
      "characterSlot" => character_slot,
      "playerToken" => player_token
    },
    socket
  ) do
    game_ref = "battle:#{battle_id}"
    {:ok, [
      active_slot,
      phase,
      character_data,
      layout_data
    ]} = Redix.pipeline(:redix, [
      ["GET", "#{game_ref}:active_slot"],
      ["GET", "#{game_ref}:phase"],
      ["HGETALL", "#{game_ref}:character:#{character_slot}"],
      ["HGETAll", "#{game_ref}:layout"]
    ])

    IO.inspect(character_data)
    character = DataUtils.clean_hget_all_data(character_data)
    layout = DataUtils.clean_hget_all_data(layout_data)

    if "#{character_slot}" == active_slot do
      x = String.to_integer(character["x"])
      y = String.to_integer(character["y"])


      movable_spaces = GameMovement.get_movable_spaces([[x, y]], 2, layout, 8)
      Redix.command(:redix, ["SET", "#{game_ref}:phase", "MOVE"])
      {:reply, {:ok, %{"movableSpaces" => movable_spaces}}, socket}
    else
      {:reply, {:error, %{"error" => "It's not this character's turn yet"}}, socket}
    end
  end

  @impl true
  def handle_in(
    "move_request",
    %{
      "battleId" => battle_id,
      "characterSlot" => character_slot,
      "playerToken" => player_token,
      "moveToSpace" => move_to_space
    },
    socket
  ) do
    game_ref = "battle:#{battle_id}"
    {:ok, [
      active_slot,
      phase,
      character_data,
      layout_data
    ]} = Redix.pipeline(:redix, [
      ["GET", "#{game_ref}:active_slot"],
      ["GET", "#{game_ref}:phase"],
      ["HGETALL", "#{game_ref}:character:#{character_slot}"],
      ["HGETAll", "#{game_ref}:layout"]
    ])
    # TODO add path finding

    character = DataUtils.clean_hget_all_data(character_data)
    layout = DataUtils.clean_hget_all_data(layout_data)

    if "#{character_slot}" == active_slot do
      x = String.to_integer(character["x"])
      y = String.to_integer(character["y"])


      movable_spaces = GameMovement.get_movable_spaces([[x, y]], 2, layout, 8)
      if Enum.member?(movable_spaces, move_to_space) do
        [move_to_x, move_to_y] = move_to_space
        next_slot = rem(String.to_integer(active_slot), 2) + 1
        {:ok, [
          _active_slot_res,
          _phase_res,
          _character_data_res,
          _layout_del_res,
          _layout_set_res,
          new_character_data,
          new_layout_data
        ]} = Redix.pipeline(:redix, [
          ["SET", "#{game_ref}:active_slot", "#{next_slot}"],
          ["SET", "#{game_ref}:phase"],
          ["HSET", "#{game_ref}:character:#{character_slot}", "x", "#{move_to_x}", "y", "#{move_to_y}"],
          ["HDEL", "#{game_ref}:layout", "#{x}_#{y}"],
          ["HSET", "#{game_ref}:layout", "#{move_to_x}_#{move_to_y}", "character_#{active_slot}"],
          ["HGETAll", "#{game_ref}:character:#{character_slot}"],
          ["HGETAll", "#{game_ref}:layout"]
        ])

        new_character = DataUtils.clean_hget_all_data(new_character_data)
        new_layout = DataUtils.clean_hget_all_data(new_layout_data)

        move_update_payload = %{
          "layout" => new_layout,
          "character" => new_character,
          "activeSlot" => next_slot
        }
        broadcast(socket, "move_update", move_update_payload)
        {:noreply, socket}
        # {:reply, {:ok, move_update_payload}, socket}
      else
        {:reply, {:error, %{"error" => "Can't move there"}}, socket}
      end
    else
      {:reply, {:error, %{"error" => "It's not this character's turn yet"}}, socket}
    end
  end



  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
