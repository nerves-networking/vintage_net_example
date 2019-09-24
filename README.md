# VintageNetExample

This is an example of a minimal Nerves project that uses
[`vintage_net`](https://hex.pm/packages/vintage_net). Since `vintage_net` is
incompatible with
[`nerves_init_gadget`](https://hex.pm/packages/nerves_init_gadget), `mix
nerves.new` won't help you get a project going quickly. Copy this project
instead.

Why `vintage_net`? The short answer is that it became terribly hard to maintain
`nerves_network` and add in features like WiFi AP mode support, multi-homed
networking, and simple network status changes notifications without breaking
someone's production device. It also provides a little more functionality to
lessen the amount of code needed to go from prototype to production device.

## Example features

The goal is feature parity with the apps created by `mix nerves.new`. Here's the
current status.

* [x] Wired Ethernet and WiFi networking with dynamically assigned addresses
* [x] ssh and sftp support (defaults to using your `~/.ssh/id_*.pub` keys)
* [x] Push-based firmware updates via `nerves_firmware_ssh`
* [ ] Static IP addressing (not supported by `vintage_net` yet)
* [x] mDNS advertisements to find the device (`nerves.local` and
  `nerves-wxyz.local` work)
* [x] Set the time using NTP (`mix nerves.new` doesn't do this, but it's one
  of the most frequent additions)
* [ ] Start Erlang distribution
* [x] USB gadget mode support (1 wire for power, network, console on RPi0, RPi
  3A+, and BeagleBone)

## Configuration

The fast way of getting started is hardcoding your network configuration in the
`config/target.exs`. The default setup anticipates a wired Ethernet interface on
`eth0` and a WiFi interface on `wlan0`. It's ok if you don't have one of those
network interfaces on your board since VintageNet will ignore it. If you're
using WiFi, start out by hardcoding your ssid and password here.

At runtime, you can change the network configuration by calling
[`VintageNet.configure/2`](https://hexdocs.pm/vintage_net/VintageNet.html#configure/2).
VintageNet persists the new configuration to the application partition so that
it will be around on the next boot. See the [VintageNet
docs](https://hexdocs.pm/vintage_net/readme.html#wired-ethernet) for
configuration examples.

At some point you'll want reasonable defaults in the `config/target.exs` (i.e.,
not your personal ssid/password) and then implement a way to configue the
network in your application. If you're using WiFi, take a look at
[`vintage_net_wizard`](https://github.com/nerves-networking/vintage_net_wizard)
for a library that puts your device into AP mode and starts a webserver to
configure the network.

## Building

Copy, clone or download this repository and then run the following:

```sh
cd vintage_net_example

# Set the target to your hardware. Only official Nerves systems are supported
# by this repository, but feel free to edit the `mix.exs` if you have something
# different.
export MIX_TARGET=rpi3
mix deps.get
mix firmware

# Insert a MicroSD card or whatever media your board takes
mix burn
```

After this is running on your board, you should be able to push updates over
WiFi or Ethernet. You'll need the upgrade script:

```sh
mix firmware.gen.script
```

Then run:

```sh
./upload <your board's IP address>
```

See [NervesHub](https://nerves-hub.org) for a managed approached to firmware
updates with Nerves.

