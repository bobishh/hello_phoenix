defmodule HelloPhoenix.Repo.Migrations.AddConfirmedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed, :boolean
    end
  end
end
