defmodule HelloPhoenix.PostController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Post
  alias HelloPhoenix.Auth

  plug :authenticate when action in [:new, :create, :delete]

  def index(conn, _params) do
    posts = Repo.all(Post)
    render conn, "index.html", posts: posts
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset post
    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)
    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> redirect to: post_path(conn, :index)
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.delete(Post, id)
    conn
    |> redirect to: post_path(conn, :index)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset %Post{}, post_params
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created.")
        |> redirect to: post_path(conn, :index)
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render conn, "post.html", post: post
  end

  defp authenticate(conn, opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be signed in.")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

end
