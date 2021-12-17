default["imv"]["client"]["system"]["short_hostname"]   = "imvlandau-client"
default["imv"]["client"]["npm_command"]                = "npm start"
default["imv"]["client"]["https"]                      = "true"
default["imv"]["client"]["port"]                       = "8080"
default["imv"]["client"]["port_ssl"]                   = "8443"
default["imv"]["client"]["api_target"]                 = "http://imvlandau-api:80/"
default["imv"]["client"]["api_target_ssl"]             = "https://imvlandau-api:443/"
default["imv"]["client"]["react_app_auth0_domain"]     = ""
default["imv"]["client"]["react_app_auth0_client_id"]  = ""
default["imv"]["client"]["react_app_auth0_audience"]   = ""
default["imv"]["client"]["react_app_base_url"]         = "/api"

default["imv"]["api"]["system"]["short_hostname"]      = "imvlandau-api"
default["imv"]["api"]["port"]                          = "80"
default["imv"]["api"]["port_ssl"]                      = "443"
default["imv"]["api"]["server_name"]                   = "localhost"
default["imv"]["api"]["server_alias"]                  = ""
default["imv"]["api"]["server_admin"]                  = "s.aburab@gmail.com"
default["imv"]["api"]["document_root"]                 = "/var/www/imvlandau-api/public"
default["imv"]["api"]["site_conf"]                     = "imvlandau-api"
default["imv"]["api"]["site_conf_ssl"]                 = "imvlandau-api-ssl"
default["imv"]["api"]["path_error_log"]                = "/var/log/apache2/imv-error.log"
default["imv"]["api"]["path_access_log"]               = "/var/log/apache2/imv-access.log"
default["imv"]["api"]["timezone"]                      = "Europe/Berlin"

default["imv"]["database"]["system"]["short_hostname"] = "imvlandau-database"
default["imv"]["database"]["name"]                     = "imvlandau"
default["imv"]["database"]["root"]                     = "postgres"
default["imv"]["database"]["root_password"]            = "PgAdm1nP4ssw0d"
default["imv"]["database"]["user"]                     = "imvadmin"
default["imv"]["database"]["user_password"]            = "UserP4ssw0rd"
default["imv"]["database"]["port"]                     = 5432
default["imv"]["database"]["version"]                  = "12"
default["imv"]["database"]["config"]                   = { "listen_addresses": "*" }
default["imv"]["database"]["config_name"]              = "imvlandau-postgresql"
default["imv"]["database"]["locale"]                   = "en_US.UTF-8"
default["imv"]["database"]["dump"]                     = "imv_participant.sql"

default["imv"]["git"]["name"]                          = "imvadmin"
default["imv"]["git"]["email"]                         = "imvadmin@imv-landau.de"

default["imv"]["home"]                                 = "/home/vagrant"
default["imv"]["user"]                                 = "vagrant"
default["imv"]["owner"]                                = "vagrant"
default["imv"]["group"]                                = "vagrant"
default["imv"]["ssl_ca_file"]                          = "/etc/ssl/imvlandau.rootCA.pem"
default["imv"]["ssl_crt_file"]                         = "/etc/ssl/imvlandau.server.crt"
default["imv"]["ssl_key_file"]                         = "/etc/ssl/imvlandau.server.key"
default["imv"]["aws_access_key_id"]                    = ""
default["imv"]["aws_secret_access_key"]                = ""
default["imv"]["aws_price_list_service_enpoint"]       = "us-east-1"
default["imv"]["aws_ec2_service_enpoint"]              = "us-east-2"
