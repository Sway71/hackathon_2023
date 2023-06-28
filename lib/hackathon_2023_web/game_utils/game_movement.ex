defmodule Hackathon2023Web.GameUtils.GameMovement do
  def directions do
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
  end

  def get_movable_spaces(tiles, moves_left, layout, map_size) do
    if moves_left > 0 do
      new_tiles = for tile <- tiles, reduce: tiles do
        acc ->
          [x, y] = tile
          frontier_tiles = Enum.filter(
            get_frontier_tiles(x, y, layout, map_size),
            fn new_tile -> !Enum.member?(acc, new_tile) end
          )

          frontier_tiles ++ acc
      end

      get_movable_spaces(new_tiles, moves_left - 1, layout, map_size)
    else
      tiles
    end
  end

  def get_frontier_tiles(x, y, layout, map_size) do
    frontier_tiles = for [dir_x, dir_y] <- directions(),
        x + dir_x >= 0 && y + dir_y >= 0,
        x + dir_x < map_size && y + dir_y < map_size,
        !Map.has_key?(layout, "#{x + dir_x}_#{y + dir_y}") do
          [x + dir_x, y + dir_y]
    end

    frontier_tiles
  end

  def get_path_to_space(start_pos, end_pos, map_data) do

  end
end
