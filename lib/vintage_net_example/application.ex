defmodule VintageNetExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    start_ssh()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VintageNetExample.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: VintageNetExample.Worker.start_link(arg)
        # {VintageNetExample.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: VintageNetExample.Worker.start_link(arg)
      # {VintageNetExample.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: VintageNetExample.Worker.start_link(arg)
      # {VintageNetExample.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:vintage_net_example, :target)
  end

  def start_ssh() do
    # Reuse keys from `nerves_firmware_ssh` so that the user only needs one
    # config.exs entry.
    authorized_keys =
      Application.get_env(:nerves_firmware_ssh, :authorized_keys, [])
      |> Enum.join("\n")

    decoded_authorized_keys = :public_key.ssh_decode(authorized_keys, :auth_keys)

    cb_opts = [authorized_keys: decoded_authorized_keys]

    # Nerves stores a system default iex.exs. It's not in IEx's search path,
    # so run a search with it included.
    iex_opts = [dot_iex_path: find_iex_exs()]

    # Reuse the system_dir as well to allow for auth to work with the shared
    # keys.
    :ssh.daemon(22, [
      {:id_string, :random},
      {:key_cb, {Nerves.Firmware.SSH.Keys, cb_opts}},
      {:system_dir, Nerves.Firmware.SSH.Application.system_dir()},
      {:shell, {Elixir.IEx, :start, [iex_opts]}},
      {:subsystems, [:ssh_sftpd.subsystem_spec(cwd: '/')]}
    ])
  end

  defp find_iex_exs() do
    [".iex.exs", "~/.iex.exs", "/etc/iex.exs"]
    |> Enum.map(&Path.expand/1)
    |> Enum.find("", &File.regular?/1)
  end
end
