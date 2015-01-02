[supervisord]
nodaemon=true

[program:pia_transmission_monitor]
command=python3 -u /usr/local/bin/pia_transmission_monitor
pidfile=/pia_transmission_monitor.pid
stdout_logfile={{ TRANSMISSION_HOME }}/supervisord.log
stderr_logfile={{ TRANSMISSION_HOME }}/supervisord.log