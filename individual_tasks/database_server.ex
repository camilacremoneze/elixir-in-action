defmodule DatabaseServer do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self})
    receive do
      {:response, value} -> value
    end
  end
  
  defp loop(current_value) do
    new_value = receive do
      {:value, caller} -> send(caller, {:response, current_value})
        current_value
      {:add, value} -> current_value + value
      {:sub, value} -> current_value - value
      {:mult, value} -> current_value * value
      {:div, value} -> current_value / value

      invalid_request ->
        IO.puts("Invalid request #{inspect invalid_request}")
        current_value  
    end

    loop(new_value)
  end

  def add(server_pid, value), do: send(server_pid, {:add, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def mult(server_pid, value), do: send(server_pid, {:mult, value})
  def div(server_pid, value), do: send(server_pid, {:div, value})
end
