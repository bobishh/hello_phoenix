defmodule HelloPhoenix.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :text, :binary
      add :user_id, :integer
      timestamps
    end
  end
end
