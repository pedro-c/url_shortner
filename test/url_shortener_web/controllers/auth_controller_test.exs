defmodule UrlShortenerWeb.AuthControllerTest do
  use UrlShortenerWeb.ConnCase

  test "GET /auth redirects to github" do
    assert build_conn()
    |> get("/auth")
    |> redirected_to() == UrlShortener.GitHub.Test.authorize_url!
  end

  test "GET /auth/callback?code=<code> puts the current user in the session" do
    conn = build_conn() |> get("/auth/callback?code=test")
    assert redirected_to(conn) == "/"

    current_user = get_session(conn, :current_user)
    user = Repo.one!(from u in User, select: u)

    assert current_user.id == user.id
    assert current_user.name == UrlShortener.GitHub.Test.github_user["name"]
    assert current_user.avatar_url == UrlShortener.GitHub.Test.github_user["avatar_url"]
  end

  test "GET /auth/callback?code=<code> creates a user if they're not already in the db" do
    assert user_count() == 0
    build_conn() |> get("/auth/callback?code=test")
    assert user_count() == 1

    user = Repo.one!(from u in User, select: u)

    assert user.name == "Chris McGrath"
    assert user.github_id == UrlShortener.GitHub.Test.github_user["id"]
    assert user.avatar_url == UrlShortener.GitHub.Test.github_user["avatar_url"]
    assert user.github_user == UrlShortener.GitHub.Test.github_user
  end

  test "GET /auth/callback?code=<code> uses the existing user if their github id is already in the db" do
    user = Repo.insert!(%User{name: "Test User", github_id: UrlShortener.GitHub.Test.github_user["id"], github_user: UrlShortener.GitHub.Test.github_user})
    current_user = build_conn()
    |> get("/auth/callback?code=test")
    |> get_session(:current_user)
    assert current_user.id == user.id
  end

  defp user_count do
    Repo.one(from(u in User, select: count(u.id)))
  end
end
