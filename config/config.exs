# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :vintage_net_example, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :vintage_net],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  import_config "target.exs"
end

config :mdns_lite,
  # Use these values to construct the DNS resource record responses
  # to a DNS query.
  mdns_config: %{
    host: :hostname,
    ttl: 120
  },
  # A list of this host's services. NB: There are two other mDNS values: weight
  # and priority that both default to zero unless included in the service below.
  # Example service specification:
  # %{
  #   name: "Secure Socket",
  #   protocol: "ssh",
  #   transport: "tcp",
  #   port: 22
  # }
  services: [
    %{
      name: "Secure Socket",
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "SSH File Transfer",
      protocol: "sftp",
      transport: "tcp",
      port: 21
    },
    %{
      name: "Erlang Port Mapper",
      protocol: "erlang",
      transport: "tcp",
      port: 4369
    },
  ]
