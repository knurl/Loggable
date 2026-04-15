import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(LoggableMacros)
import LoggableMacros

let testMacros: [String: Macro.Type] = [
    "Loggable": LoggableMacro.self,
]
#endif

final class LoggableTests: XCTestCase {
    func testAddsStaticLogMember() throws {
        #if canImport(LoggableMacros)
        assertMacroExpansion(
            """
            @Loggable
            class Foo {
                func bar() {}
            }
            """,
            expandedSource:
            """
            class Foo {
                func bar() {}
            
                nonisolated private static let log = os.Logger(
                    subsystem: Bundle.main.bundleIdentifier!,
                    category: "Foo"
                )
                var log: os.Logger { Self.log }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
