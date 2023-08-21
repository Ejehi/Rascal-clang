module AST

extend CSyntax;

data Program = statement(list[Stmt] stmt);

data Stmt = expression(Exp exp)
            | declaration(Declaration decl)
            | initialization(Initialize init)
            | block(list[Stmt] blockstmt)
            | returnKeyword(list[Exp] explist)
            | breakKeyword()
            | continueKeyword()
            | forLoop(list[Exp] explist1, list[Exp] explist2, list[Exp] explist3, Stmt stmt)
            | ifStmt(Exp exp, Stmt stmt)
            | ifElseStmt(Exp exp, Stmt stmt1, Stmt stmt2)
            | whileLoop( Exp exp, Stmt stmt)
            | funcDeclStmt(FunctionDecl functiondecl)
            | structureCreateStmt(StructureCreate struct)
            ;

data Declaration = declaration(VarType var_type, list[str] id);

data Initialize = initialization(VarType var_type, str id, Exp exp);

data VarType = integer()
                | character()
                | boolean()
                | \float()
                ;

data Parameter = param(VarType var_type, str id);
data ParameterList = paramlist(list[Parameter] param_list);
data ParameterDecl = paramdecl(list[Parameter] paramdecl_list);


data FunctionDecl = funcdecl(VarType var_type, str id, list[ParameterList] func_params, Stmt stmt);

data StructureCreate = struct_create(str id, list[ParameterDecl] struct_params);

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
        | assign(Exp lhs, Exp rhs) 
        ;
