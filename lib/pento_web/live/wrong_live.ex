defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  # alias PentoWeb.Router.Helpers, as: Routes

  def mount(params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       time: time(),
       message: "Make a guess:",
       secret_number: generate_a_random_number(),
       over: false
     )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    current_score = socket.assigns.score
    secret_number = socket.assigns.secret_number
    {message, score, win} = check_guess(guess, current_score, secret_number)

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time(),
        over: win
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <%= if @over do %>
      <%= live_patch to: Routes.live_path(@socket, __MODULE__), replace: true do %>
        <button>Try again!</button>
      <% end %>
    <% end %>
    """
  end

  def time() do
    DateTime.utc_now()
    |> to_string()
  end

  def generate_a_random_number() do
    :rand.uniform(10)
  end

  def check_guess(guess, current_score, secret_number) do
    IO.inspect(secret_number)
    {gn, _} = Integer.parse(guess)
    IO.inspect(gn)

    if gn == secret_number do
      message = "You've won!"
      score = current_score + 1
      {message, score, true}
    else
      message = "Your guess: #{guess}. Wrong. Guess again"
      score = current_score - 1
      {message, score, false}
    end
  end
end
