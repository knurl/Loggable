// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(`log`))
public macro Loggable() = #externalMacro(module: "LoggableMacros", type: "LoggableMacro")
