defmodule HelloPhoenix.LayoutView do
  use HelloPhoenix.Web, :view

  def user_menu(conn) do
    if conn.assigns.current_user != nil do
      render "user_menu.html", conn: conn
    end
  end
end
