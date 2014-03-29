default["sslh"]["source"]["version"] = "1.15"
default["sslh"]["source"]["checksum"] = "fc854cc5d95be2c50293e655b7427032ece74ebef1f7f0119c0fc3e207109ccd"
default[:sslh][:options] = "--user nobody --pidfile $PIDFILE -p  0.0.0.0:8443 --ssl 127.0.0.1:443 --ssh 127.0.0.1:22"
