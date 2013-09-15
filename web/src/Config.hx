/* Copyright (c) 2013 Meep Factory OU */

package;

import saffron.Data;
import saffron.tools.MySQL;

class Config {
    public static inline var application_api = 'api';
    public static inline var log_level = 0;
    public static inline var log_root = 'logs';
    public static inline var media_prefix = 'http://127.0.0.1/media/download/';
    public static inline var media_root = 'media';
    public static inline var mysql_connections = 10;
    public static inline var mysql_salt = 'devoler';
    public static inline var mysql_pool_size = 10;
    public static inline var mysql_database = 'reloved';
    public static inline var mysql_host = 'localhost';
    public static inline var mysql_port = 3306;
    public static inline var mysql_user = 'www';
    public static inline var mysql_password = 'Bv34ka20xQ';
    public static inline var port_api = 3000;
    public static inline var session_length = 60;
    public static inline var session_length_http = 3600;
    
    public static function mysql_adapter() : DataAdapter {
        return MySQL.createConnectionFromPool({
            host: Config.mysql_host,
            port: Config.mysql_port,
            user: Config.mysql_user,
            password: Config.mysql_password,
            database: Config.mysql_database,
            poolSize: Config.mysql_connections
        });
    }
}
