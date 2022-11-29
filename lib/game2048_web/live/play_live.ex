defmodule Game2048Web.PlayLive do
  use Game2048Web, :live_view
  require Logger

  alias Game2048.{Board, GridSize, Coordinate}

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("mounting")
    {:ok, start_new_game(socket, 6, 2)}
  end

  @impl true
  def handle_event(
        "new_game",
        %{
          "board_config" => %{
            "grid_size" => grid_size,
            "obstacle_count" => obstacle_count
          }
        }, socket) do
    Logger.info(
      "New game requested with #{grid_size} columns, #{grid_size} rows and #{obstacle_count} obstacles"
    )

    socket =
      start_new_game(
        socket,
        String.to_integer(grid_size),
        String.to_integer(obstacle_count)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("move", %{"direction" => direction}, socket) do
    Logger.info("Move event received: #{direction}")
    socket = move(socket, String.to_existing_atom(direction))

    {:noreply, socket}
  end

  defp start_new_game(socket, grid_size, obstacle_count) do
    board = Board.new(GridSize.new(grid_size, grid_size), obstacle_count)

    socket
    |> assign(:grid_size, grid_size)
    |> assign(:obstacle_count, obstacle_count)
    |> assign(:board, board)
  end

  defp move(socket, direction) do
    board = socket.assigns.board

    socket
    |> assign(:board, Board.move(board, direction))
  end
end
