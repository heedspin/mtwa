RTurk::logger.level = Logger::DEBUG
RTurk.setup( AppConfig.rturk_access_key_id,
             AppConfig.rturk_secret_access_key,
             :sandbox => true )
