# ESP32 Serial Flasher

Home Assistant add-on that exposes one USB UART device over TCP using RFC2217.
This allows a client such as `esptool` on macOS to access a UART-connected ESP32
through the Home Assistant host.

> **Important:** RFC2217 transports a serial port; it does not tunnel native USB.
> This add-on is intended for USB-to-UART bridges (FTDI, CP210x, CH340, etc.).
> It does not make an ESP32-S3 native USB Serial/JTAG interface remotely available.

## Initial scope

- Select one serial device exposed to Home Assistant OS.
- Publish it as an RFC2217 service on TCP port 2010.
- Configure the serial baud rate.
- Keep firmware flashing on the client (for example, the MacBook).

## Install

1. Replace the repository URL and maintainer in `repository.yaml`.
2. Publish this repository to GitHub.
3. In Home Assistant, add the repository URL in **Settings → Apps → App store → ⋮ → Repositories**.
4. Install **ESP32 Serial Flasher**.
5. Select the FTDI device and start the app.

The selected device must be visible to HAOS. The known device path from the test
system is `/dev/serial/by-id/usb-FTDI_ZiGate_ZIGATE+-if00-port0`.

## Test from macOS

Install pySerial:

```bash
python3 -m pip install pyserial
```

Check TCP reachability:

```bash
nc -vz HOME_ASSISTANT_IP 2010
```

Open an RFC2217 serial session:

```bash
python3 -m serial.tools.miniterm   rfc2217://HOME_ASSISTANT_IP:2010 115200
```

For an ESP32 connected to the UART bridge, try identifying the chip:

```bash
python3 -m pip install esptool
python3 -m esptool --port 'rfc2217://HOME_ASSISTANT_IP:2010' chip-id
```

If automatic reset does not work, the ESP32 may need to be placed in download
mode manually. RTS/DTR support depends on the USB-UART bridge wiring and board
circuit.

## Security

The RFC2217 listener is a raw serial access endpoint and has no authentication
in this initial version. Do not expose TCP port 2010 to the Internet. Restrict
access to a trusted LAN or VPN and use a firewall.

## Known limitations

- One client at a time.
- No web UI for flashing.
- No native USB passthrough.
- The FTDI ZiGate currently detected by HAOS is a serial adapter. Its TX/RX
  wiring must actually reach the ESP32 being flashed; detection alone does not
  establish that connection.
