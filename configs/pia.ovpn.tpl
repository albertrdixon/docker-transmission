client
dev tun
proto tcp
remote {{ OPENVPN_GATEWAY }} 443
resolv-retry infinite
nobind
persist-key
persist-tun
ca pia.crt
tls-client
remote-cert-tls server
auth-user-pass /pia.cred
comp-lzo
reneg-sec 0
crl-verify pia.pem
log ovpn-pia.log
verb 4
mute 5