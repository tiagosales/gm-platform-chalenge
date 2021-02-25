package com.greenmile.platformchalenge

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.reactive.function.server.router


@Configuration
class RoutingConfiguration {

    @Bean
    fun route(platformChalengeHandler: PlatformChalengeHandler) = router {
        "/".nest {
            GET(platformChalengeHandler::hello)
        }
    }
}