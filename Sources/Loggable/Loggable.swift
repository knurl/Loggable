@_exported import os

@attached(member, names: named(`log`))
public macro Loggable() = #externalMacro(module: "LoggableMacros", type: "LoggableMacro")
