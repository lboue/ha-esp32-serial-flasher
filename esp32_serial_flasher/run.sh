#!/command/with-contenv bashio
set -e

DEVICE="$(bashio::config 'device')"
BAUDRATE="$(bashio::config 'baudrate')"

if [ -z "${DEVICE}" ] || [ ! -c "${DEVICE}" ]; then
    bashio::log.error "Serial device is missing or is not a character device: ${DEVICE}"
    exit 1
fi

bashio::log.info "Starting ser2net RFC2217 bridge"
bashio::log.info "Serial device: ${DEVICE}"
bashio::log.info "Initial baud rate: ${BAUDRATE}"
bashio::log.warning "TCP/2010 has no authentication. Restrict access to a trusted LAN or VPN."

cat > /run/ser2net.yaml <<EOF
connection: &esp32_serial
  accepter: telnet(rfc2217),tcp,2010
  connector: serialdev,
    ${DEVICE},
    ${BAUDRATE}n81,local
EOF

exec ser2net -n -c /run/ser2net.yaml
