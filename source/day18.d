import std;

enum Op
{
    add = '+',
    multiply = '*'
}

class Expr
{
    string text;
    Expr sub_expression;
    static Expr function(string) parse_func = &parse;
    this(string text)
    {
        this.text = text;
    }

    long evaluate()
    {
        if (text.isNumeric)
        {
            return text.to!long;
        }
        sub_expression = parse_func(text);
        // format!"%s is %d"(text, sub_expression.evaluate).writeln;
        return sub_expression.evaluate();
    }

    override string toString() const
    {
        return text;
    }
}

class BinaryExpr : Expr
{
    Expr lhs;
    Expr rhs;
    Op type;
    this(Expr lhs, Expr rhs, Op type)
    {
        this.lhs = lhs;
        this.rhs = rhs;
        this.type = type;
        super(format!"(%s %c %s)"(lhs.text, type, rhs.text));
    }

    override long evaluate()
    {
        long ret;
        if (type == Op.add)
        {
            ret = lhs.evaluate + rhs.evaluate;
        }
        else if (type == Op.multiply)
        {
            ret = lhs.evaluate * rhs.evaluate;
        }
        else
        {
            enforce(false, "Not implemented yet");
        }
        return ret;
    }

}

void split_in_expr(string expr, out string[] splits, out Op[] ops)
{
    size_t i = 0;
    while (i < expr.length)
    {
        if (expr[i].isDigit)
        {
            splits ~= [expr[i]];
        }
        else if (expr[i] == '(')
        {
            size_t start = i;
            size_t lvl = 1;
            while (0 != lvl)
            {
                i++;
                if (expr[i] == '(')
                {
                    lvl++;
                }
                else if (expr[i] == ')')
                {
                    lvl--;
                }
            }
            splits ~= expr[start + 1 .. i].dup;
        }
        else if (expr[i] == '+' || expr[i] == '*')
        {
            ops ~= cast(Op) expr[i];
        }
        else
        {
            "ohno".writeln;
        }
        i += 2;
    }

}

auto parse(string expr)
{
    string[] splits;
    Op[] ops;
    expr.split_in_expr(splits, ops);

    Expr[] exprs;
    exprs ~= new Expr(splits.front);
    for (size_t j = 1; j < splits.length; j++)
    {
        Expr rhs = new Expr(splits[j]);
        BinaryExpr bin = new BinaryExpr(exprs.back, rhs, ops[j - 1]);
        exprs ~= bin;
    }
    return exprs.back;
}

auto parse2(string expr)
{
    string[] splits;
    Op[] ops;
    expr.split_in_expr(splits, ops);

    auto sub_exprs = splits.map!(x => new Expr(x));
    // sub_exprs.writeln;
    // ops.writeln;
    Expr[] new_exprs = [sub_exprs.front];
    Op[] new_ops;

    foreach (index, op; ops.enumerate)
    {
        if (op == Op.add)
        {
            auto bin = new BinaryExpr(new_exprs.back, sub_exprs[index + 1], op);
            new_exprs.popBack;
            new_exprs ~= bin;
        }
        else
        {
            new_exprs ~= sub_exprs[index + 1];
            new_ops ~= op;
        }
    }
    Expr ret = new_exprs.front;
    // new_exprs.writeln;
    // new_ops.writeln;
    foreach (index, op; new_ops.enumerate)
    {
        ret = new BinaryExpr(ret, new_exprs[index + 1], op);
    }
    return ret;
}

void main()
{
    File("input").byLine
        .map!(to!string)
        .map!(x => new Expr(x).evaluate)
        .sum
        .writeln;
    Expr.parse_func = &parse2;

    File("input").byLine
        .map!(to!string)
        .map!(x => new Expr(x).evaluate)
        .sum
        .writeln;
}

unittest
{
    assert(new Expr("2 * 3 + (4 * 5)").evaluate == 26);
    assert(new Expr("5 + (8 * 3 + 9 + 3 * 4 * 3)").evaluate == 437);
    assert(new Expr("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))").evaluate == 12_240);
    assert(new Expr("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2").evaluate == 13_632);
}

unittest
{
    Expr.parse_func = &parse2;
    // "2 * 3 + (4 * 5)".parse2.writeln;
    // "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2".parse2.writeln;
    assert(new Expr("2 * 3 + (4 * 5)").evaluate == 46);
    assert(new Expr("5 + (8 * 3 + 9 + 3 * 4 * 3)").evaluate == 1445);
    assert(new Expr("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2").evaluate == 23_340);
    assert(new Expr("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))").evaluate == 669_060);
}
