defmodule LivechatWeb.LoginController do
  use LivechatWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"name" => name}) do
    put_session(conn, :username, name)
    |> redirect(to: ~p"/")
  end

  def delete(conn, _params) do
    delete_session(conn, :username)
    |> redirect(to: ~p"/")
  end
end
