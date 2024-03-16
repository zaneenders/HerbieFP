public func parse(_ tokens: [Token]) -> FPCore {
    parseFPCore(0, tokens)
    let exp: Expr = .symbol(Symbol(""))
    return FPCore(exp)
}

private func parseFPCore(_ index: Int, _ tokens: [Token]) {
    var i = consumeWhiteSpace(index, tokens)
    guard peekLeftParen(i, tokens) && peekFPCore(i + 1, tokens) else {
        return
    }
    i += 2
    guard let (ci, args) = consumeArguments(i, tokens) else {
        return
    }
    i = ci
    print(i)
    print(args)
    print("here: \(tokens[i])")

}

private func consumeArguments(_ index: Int, _ tokens: [Token])
    -> (Int, [Argument])?
{
    var i = consumeWhiteSpace(index, tokens)
    guard peekLeftParen(i, tokens) else {
        return nil
    }
    i += 1
    var consumSymbols = true
    var args: [Argument] = []
    while consumSymbols {
        switch tokens[i].type {
        case .symbol(let sym):
            args.append(.symbol(Symbol(sym)))
            i += 1
        case .whiteSpace(_):
            i += 1
        default:
            consumSymbols = false
        }
    }
    i = consumeWhiteSpace(i, tokens)
    guard peekRightParen(i, tokens) else {
        return nil
    }
    return (i + 1, args)
}

private func peekSymbol(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .symbol(_):
        return true
    default:
        return false
    }
}

private func peekFPCore(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .fpcore:
        return true
    default:
        return false
    }
}

private func peekRightParen(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .rightParen:
        return true
    default:
        return false
    }
}

private func peekLeftParen(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .leftParen:
        return true
    default:
        return false
    }
}

// returns the index of token after last whitespace
private func consumeWhiteSpace(_ index: Int, _ tokens: [Token]) -> Int {
    var i = index
    var consumeWhiteSpace = true
    while consumeWhiteSpace {
        switch tokens[i].type {
        case .whiteSpace(_):
            i += 1
        default:
            consumeWhiteSpace = false
        }
    }
    return i
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
