Rails.application.config.session_store :cookie_store,
                                       secure: Rails.env.production?,
                                       expire_after: 1.year
