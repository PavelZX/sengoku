defmodule SengokuWeb.GameLive do
  use SengokuWeb, :live_view

  require Logger

  alias Sengoku.{GameServer, Game}

  @impl true
  def mount(params, session, socket) do
    user_token = session["anonymous_user_id"]
    game_id = params["game_id"]
    game_state = GameServer.get_state(game_id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Sengoku.PubSub, "game:" <> game_id)
    end

    {:ok, assign(socket,
      game_id: game_id,
      user_token: user_token,
      player_id: game_state.tokens[user_token],
      game_state: game_state
    )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="Game">
      <div class="Display">
        <h1 class="Logo">
          <a href="/">
            <img src="<%= Routes.static_path(@socket, "/images/sengoku.svg") %>" alt="Sengoku" />
          </a>
        </h1>

        <p>User Token: <%= @user_token %></p>
        <p>Player ID: <%= @player_id %></p>

        <ol class="Players">
          <%= for {player_id, player} <- @game_state.players do %>
            <li class="Player <%= if not player.active, do: "Player--inactive" %> <%= if @game_state.current_player_id == player_id, do: "Player--current" %>" style="background-color: <%= player.color %>">
              <b>
                <%= player.name %>
                <%= if player.ai do %>
                  <small class="Player-type">AI</small>
                <% end %>
              </b>
              <%= if player.unplaced_units > 0 do %>
                <span>
                  <%= player.unplaced_units %>
                  <svg class="Icon" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg" version="1.1" >
                    <use href="#icon-unit" />
                  </svg>
                </span>
              <% end %>
            </li>
          <% end %>
        </ol>

        <%= if @game_state.turn == 0 && not Map.has_key?(@game_state.tokens, @user_token) do %>
          <form phx-submit="join">
            <input type="text" name="player_name" placeholder="Player Name" required />
            <input type="submit" class="Button" value="Join Game" />
          </form>
        <% end %>

        <%= if @game_state.turn == 0 do %>
          <button class="Button" phx-click="start">Start Game</button>
        <% end %>

      </div>
      <div class="Board">
        <p>
          <code><%= inspect(@game_state) %></code>
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def handle_info({:game_updated, new_state}, socket) do
    {:noreply, assign(socket, game_state: new_state)}
  end

  @impl true
  def handle_event("join", %{"player_name" => player_name}, socket) do
    case GameServer.authenticate_player(
      socket.assigns.game_id,
      socket.assigns.user_token,
      player_name
    ) do
      {:ok, player_id, token} ->
        {:noreply, assign(socket, player_id: player_id)}
      {:error, reason} ->
        Logger.info("Failed to join game: #{reason}")
        {:noreply, socket}
    end
  end

  # @impl true
  # def handle_event("start", _params, socket) do
  #   %{type: "start_game"}

  #   {:noreply, socket}
  # end
end
