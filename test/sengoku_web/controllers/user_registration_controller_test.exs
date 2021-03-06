defmodule SengokuWeb.UserRegistrationControllerTest do
  use SengokuWeb.ConnCase, async: true

  import Sengoku.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Create an Account</h1>"
      assert response =~ "Sign In</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> login_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()
      username = valid_user_username()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "username" => username,
            "password" => valid_user_password()
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Hi, #{username}"
      assert response =~ "Settings</a>"
      assert response =~ "Sign Out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "username" => "this is much too long for a username",
            "password" => "too short"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Create an Account</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
      assert response =~ "must be between 3–20 characters without spaces"
    end
  end
end
