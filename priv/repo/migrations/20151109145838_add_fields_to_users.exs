defmodule HelloPhoenix.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmation_email_sent, :boolean
      add :token, :string
    end
  end
end
