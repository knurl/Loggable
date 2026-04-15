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
    func testStaticLogMemberWorksInClass() throws {
        #if canImport(LoggableMacros)
        assertMacroExpansion(
            """
            @Loggable
            class FooClass {
                func bar() {}
            }
            """,
            expandedSource:
            """
            class FooClass {
                func bar() {}
            
                private static let log: os.Logger = {
                    let subsystem = Bundle.main.infoDictionary? ["CFBundleIdentifier"] as? String ?? "unknown"
                    return os.Logger(subsystem: subsystem, category: "FooClass")
                }()
                var log: os.Logger { Self.log }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testStaticLogMemberWorksInActor() throws {
        #if canImport(LoggableMacros)
        assertMacroExpansion(
            """
            @Loggable
            actor FooActor {
                func bar() {}
            }
            """,
            expandedSource:
            """
            actor FooActor {
                func bar() {}
            
                private static let log: os.Logger = {
                    let subsystem = Bundle.main.infoDictionary? ["CFBundleIdentifier"] as? String ?? "unknown"
                    return os.Logger(subsystem: subsystem, category: "FooActor")
                }()
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
