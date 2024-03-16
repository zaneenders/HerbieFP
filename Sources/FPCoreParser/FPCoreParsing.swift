public func parse(_ tokens: [Token]) -> FPCore {
    let exp: Expr = .symbol(Symbol(""))
    return FPCore(exp)
}

enum Grammar {
    case fpCore
    case dimension
    case argument
    case expr
    case number
    case property
    case data
}

public struct FPCore {
    var symbol: String? = nil
    var arguments: [Argument] = []
    var properties: Properties = Properties()
    var expr: Expr

    init(_ expr: Expr) {
        self.expr = expr
    }
}

extension FPCore: Equatable {
    public static func == (lhs: FPCore, rhs: FPCore) -> Bool {
        guard lhs.symbol == rhs.symbol else {
            return false
        }
        guard lhs.arguments == rhs.arguments else {
            return false
        }
        guard lhs.properties == rhs.properties else {
            return false
        }
        guard lhs.expr == rhs.expr else {
            return false
        }
        return true
    }
}

struct Properties: Equatable {
    var props: [Symbol: Data] = [:]
}

enum Data: Equatable {
    case symbol(Symbol)
    case string(String)
}

enum Expr: Equatable {
    case symbol(Symbol)
    case number(Number)
    case operation(Operation, [Expr])  // none empty array
}

enum Number: Equatable {
    case rational(String)
    case decnum(String)
    case hexnum(String)
    case digits
}

enum Operation {
    case fabs
    case minus
    case div
    case plus
    case times
}

struct Symbol: Hashable {
    init(_ sym: String) {
        self.sym = sym
    }
    let sym: String
}

// mabye struct arguments to store parens and white space
enum Argument: Equatable {
    case symbol(Symbol)
    //( symbol dimension+ )
    //( ! property* symbol dimension* )
}
