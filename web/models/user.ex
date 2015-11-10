defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :token, :string
    field :confirmation_email_sent, :boolean
    field :confirmed, :boolean
    field :password_hash, :string

    timestamps
  end

  @required_fields ~w(name email password password_confirmation)
  @optional_fields ~w(confirmed)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def confirmation_changeset(model, params \\ :empty) do
    model
    |> cast(params, ["confirmed"])
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:username, min: 3, max: 42)
    |> put_pass_hash()
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 3, max: 42)
    |> validate_password_input()
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
  end

  defp validate_password_input(changeset) do
    cond do
      changeset.changes.password == changeset.changes.password_confirmation ->
        changeset
      true ->
        %{ changeset | valid?: false,
           errors: changeset.errors ++ [password: "Passwords don't match"]}
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{ password: pass } } ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end
end
