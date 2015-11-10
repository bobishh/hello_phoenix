defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Repo
  alias HelloPhoenix.User
  alias HelloPhoenix.Auth

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    login_result = Auth.login_by_email_and_pw(conn, email, password, repo: Repo)
    case login_result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, _conn} ->
        conn
        |> put_flash(:error, "Invalid login data")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Goodbye!")
    |> redirect(to: page_path(conn, :index))
  end

end
