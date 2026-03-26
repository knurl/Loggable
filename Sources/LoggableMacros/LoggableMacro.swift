import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LoggableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Extract the enclosing type name
        guard let typeDecl = declaration.asProtocol(DeclGroupSyntax.self),
              let identifier = typeDecl.asProtocol(NamedDeclSyntax.self)?.name.text
        else {
            return []
        }

        // Generate the static Logger property
        let decl: DeclSyntax = """
        private static let log = os.Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: "\(raw: identifier)"
        )
        """

        return [decl]
    }
}

@main
struct LoggablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoggableMacro.self
    ]
}
