defmodule HelloPhoenix.PostView do
  use HelloPhoenix.Web, :view

  def short_text(text) do
    if String.length(text) > 40 do
      String.slice(text, 0, 40)
    else
      text
    end
  end

  def submit_button_text(action) do
    case action do
      :create -> "Create post"
      :update -> "Update post"
    end
  end
end
