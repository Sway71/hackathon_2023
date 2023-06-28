defmodule Hackathon2023Web.ErrorJSONTest do
  use Hackathon2023Web.ConnCase, async: true

  test "renders 404" do
    assert Hackathon2023Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Hackathon2023Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
