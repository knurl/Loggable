import Foundation
import Loggable

@available(macOS 11.0, *)
@Loggable
final class FooBar {
    init() {
        log.info("I've just initialized myself")
    }
}
