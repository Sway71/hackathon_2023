defmodule Hackathon2023Web.PageControllerTest do
  use Hackathon2023Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
