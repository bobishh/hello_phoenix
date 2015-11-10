defmodule HelloPhoenix.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias HelloPhoenix.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def login_by_email_and_pw(conn, email, pw, opts) do
    repo = Keyword.fetch! opts, :repo
    user = repo.get_by(User, email: email)
    cond do
      user && !user.confirmed ->
        { :error, :not_confirmed, conn }
      user && checkpw(pw, user.password_hash) ->
        { :ok, login(conn, user) }
      user ->
        { :error, :unauthorized, conn }
      true ->
        { :error, :not_found, conn }
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end
end
