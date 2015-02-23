[supervisord]
nodaemon  = true
user      = root
loglevel  = {{ default .Env.SUPERVISOR_LOG_LEVEL "INFO" }}

[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[program:pia]
command                 = python3 -u /usr/local/bin/pia_transmission_monitor
autostart               = true
stdout_logfile          = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile          = /dev/stderr
stderr_logfile_maxbytes = 0