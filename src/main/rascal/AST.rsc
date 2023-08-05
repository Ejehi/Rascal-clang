module AST

extend CSyntax;

data Program = statement(list[Stmt] stmt);

data Stmt = expression(Exp exp)
            | declaration(Declaration decl)
            | block(list[Stmt] boolstmt)
            | returnKeyword(bool)
            | breakKeyword()
            | continueKeyword()
            | forLoop(bool, bool, bool, Stmt stmt)
            | ifStmt(Exp exp, Stmt stmt)
            | ifElseStmt(Exp exp, Stmt stmt1, Stmt stmt2)
            | whileLoop( Exp exp, Stmt stmt)
            | funcDeclStmt(FunctionDecl functiondecl)
            | funcCall(FunctionCall functioncall)
            | structureCreateStmt(StructureCreate struct)
            ;

data Declaration = declaration(bool, list[str] id_list, bool);

data Initialize = initialization(Exp exp);

data VarType = integer()
                | character()
                | boolean()
                | \void()
                | \float()
                ;

data Parameter = param(bool, Exp exp);
data ParameterList = param_list(list[tuple[Parameter]] parameters);
data ParameterDecl = param_decl(tuple[tuple[Parameter]] parameters);


data FunctionDecl = funcdecl(VarType var_type, str id, bool, Stmt stmt);
data FunctionCall = funccall(str id, bool);

data StructureCreate = struct_create(str id, bool);

data Exp
        = identifier(str id)
        | int_constant(int int_value)
        | float_constant(real float_value)
        | bool_constant(str bool_value)
        | char_constant(str char_value)
        | string_constant(str string_value)
        | \bracket(Exp exp)
        | post_incr(Exp exp) 
        | post_decr(Exp exp) 
        | pre_incr(Exp exp) 
        | pre_decr(Exp exp)
        | mul(Exp lhs, Exp rhs)
        | div(Exp lhs, Exp rhs) 
        | add(Exp lhs, Exp rhs) 
        | sub(Exp lhs, Exp rhs)
        | gt(Exp lhs, Exp rhs)
        | lt(Exp lhs, Exp rhs)
        // | assign(Exp lhs, Exp rhs) 
        ;
