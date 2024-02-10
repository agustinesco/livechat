defmodule LivechatWeb.LoginController do
  use LivechatWeb, :controller
  alias Livechat.UsersManager
  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"name" => name, "password" => password}) do
    case UsersManager.create(name, password) do
      :already_exists ->
        conn
        |> put_flash(:error, "Usuario ya creado")
        |> render(:new)
      {name, _password, rooms} ->
        user = %{
          username: name,
          rooms: rooms
        }

        conn
        |> put_session(:user, user)
        |> put_flash(:info, "Ingresado con exito")
        |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    delete_session(conn, :user)
    |> redirect(to: ~p"/")
  end

  def access(conn, _param) do
    render(conn, :login)
  end


  def validate_user(conn, %{"name" => name, "password" => password}) do
    case UsersManager.validate_user(name, password) do
      :invalid_credentials ->
        conn
        |> put_flash(:info, "Credenciales incorrectas")
        |> render(:login)
      :not_found ->
        conn
        |> put_flash(:info, "Usuario inexistente")
        |> render(:login)
        {name, _password, rooms} ->
        user = %{
          username: name,
          rooms: rooms
        }

        conn
        |> put_session(:user, user)
        |> put_flash(:info, "Ingresado con exito")
        |> redirect(to: ~p"/")
    end
  end
end
