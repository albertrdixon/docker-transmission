client
dev tun
proto {{ .Env.OPENVPN_PROTO }}
remote {{ .Env.OPENVPN_GATEWAY }} {{ .Env.OPENVPN_GATEWAY_PORT }}
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