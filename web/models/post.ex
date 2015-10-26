defmodule HelloPhoenix.Post do
  use HelloPhoenix.Web, :model

  schema "posts" do
    field :text, :binary
    field :user_id, :integer
    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(text user_id), [])
  end

end
