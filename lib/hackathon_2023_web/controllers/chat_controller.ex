defmodule Hackathon2023Web.ChatController do
  use Hackathon2023Web, :controller

  def show(conn, %{"id" => room}) do
    render(conn, "show.html", room: room)
  end
end
