[File_Paths]
pia_credentials = /pia.cred
pia_client_id = /pia_client_id
transmission_rc = {{ .Env.TRANSMISSION_HOME }}/settings.json
netrc = /root/.netrc

[PIA]
url = https://www.privateinternetaccess.com/vpninfo/port_forward_assignment

[Server]
tun_device = tun0
transmission_command = transmission-daemon -r 0.0.0.0 --config-dir {{ .Env.TRANSMISSION_HOME }} --logfile {{ .Env.TRANSMISSION_LOG }}
transmission_uid = 0
transmission_gid = 0
openvpn_command = openvpn --cd {{ .Env.OPENVPN_HOME }} --daemon ovpn-pia --config {{ .Env.OPENVPN_HOME }}/pia.ovpn --writepid /var/run/openvpn.pia.pid --status /var/run/openvpn.pia.status 10