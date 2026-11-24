# ESP32 Serial Flasher

This add-on exposes the selected serial device on TCP port 2010 using RFC2217.

## Configuration

- **Serial device:** choose the USB UART device shown by Home Assistant.
- **Baud rate:** initial UART speed; esptool may request a different speed using
  RFC2217 if supported by the bridge and server.

## Client example (macOS)

```bash
python3 -m pip install pyserial esptool
nc -vz HOME_ASSISTANT_IP 2010
python3 -m esptool --port 'rfc2217://HOME_ASSISTANT_IP:2010' chip-id
```

Use a trusted LAN or VPN only. The service has no authentication.
