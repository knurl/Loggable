import Foundation
import Loggable

@available(macOS 11.0, *)
@Loggable
final class FooBar {
    init() {
        log.info("I've just initialized myself")
    }
}

@Loggable
actor BazBar {
    init() {
        log.info("I've just initialized myself")
        log.error("This is an error message")
        log.debug("This is a debug message")
    }
}
