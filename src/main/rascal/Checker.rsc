module Checker

import CSyntax;
extend analysis::typepal::TypePal;

data AType   
    = boolType()    
    | intType()
    | floatType()
    | charType()                                     
    | stringType()
    | structType(str name)                                   
    ;
    
str prettyAType(boolType()) = "bool";
str prettyAType(intType()) = "int";
str prettyAType(floatType()) = "float";
str prettyAType(charType()) = "char";
str prettyAType(stringType()) = "string";
str prettyAType(structType(name)) = "struct <name>";

data ScopeRole 
    = functionScope()
    | loopScope()
    ;


data LoopInfo = loopInfo(str name);
data functionInfo = functionInfo(str name);


data IdRole
    = variableId()
    | functionId()
    | structId()
    ;

// Collect Statements

void collect(current: (Stmt) `<Exp e> ;`, Collector c) {
    collect(e, c);
}

void collect(current: (Stmt) `<Declaration declaration> ;`, Collector c) {
    collect(declaration, c);
}

void collect(current: (Stmt) `<Initialize initialization> ;`, Collector c) {
    collect(initialization, c);
}

void collect(current: (Stmt) `{ <Stmt* stmts> }`, Collector c) {
    for(statement <- stmts) collect(statement, c);
}

void collect(current: (Stmt) `return <Exp? exp> ;`, Collector c) {
    for(e <- exp) collect(e, c);
}

void collect(current: (Stmt) `break ;`, Collector c) {}

void collect(current: (Stmt) `continue ;`, Collector c) {}


void collect(current: (Stmt) `if ( <Exp cond> ) <Stmt statement>`, Collector c){
    c.requireEqual(cond, boolType(), error(cond, "Condition should be `bool`, found %t", cond));
    collect(cond, statement, c);
}

void collect(current: (Stmt) `if ( <Exp cond> ) <Stmt ifStatement> else <Stmt elseStatement>`, Collector c){
    c.requireEqual(cond, boolType(), error(cond, "Condition should be `bool`, found %t", cond));
    collect(cond, ifStatement, elseStatement, c);
}

// Loops
void collect(current: (Stmt) `while ( <Exp cond> ) <Stmt statement>`, Collector c){
    c.enterScope(current);
        loopName = "whileLoop";
        c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
        c.requireEqual(cond, boolType(), error(cond, "Condition should be `bool`, found %t", cond));
        collect(cond, statement, c);
    c.leaveScope(current);

}

void collect(current: (Stmt) `for ( <Exp? exp1> ; <Exp? exp2> ; <Exp? exp3> ) <Stmt stmt>`, Collector c){
    c.enterScope(current);
        loopName = "forLoop";
        c.setScopeInfo(c.getScope(), loopScope(), loopInfo(loopName));
        c.requireEqual(exp2, boolType(), error(exp2, "Condition should be `bool`, found %t", exp2));
        for(e1 <- exp1) collect(e1, c);
        for(e2 <- exp2) collect(e2, c);
        for(e3 <- exp3) collect(e3, c);
        collect(stmt, c);
    c.leaveScope(current);
}

void collect(current: (Stmt) `<FunctionDecl functiondecl>`, Collector c) {
    collect(functiondecl, c);
}

void collect(current: (Stmt) `<StructureCreate structcreate> ;`, Collector c) {
    collect(structcreate, c);
}

// Collect Declaration and Initialization
void collect(current: (Declaration) `<VarType tp> <{ Id "," }+ id_list>`, Collector c) {
    for(id <- id_list) {
        c.define("<id>", variableId(), id, defType(tp));
        collect(tp, id, c);
    }
}

void collect(current: (Initialize) `<VarType tp> <Id id> = <Exp e>`, Collector c) {
    c.define("<id>", variableId(), id, defType(tp));
    c.requireEqual(id, e, error(current, "Lhs %t should have the same type as Rhs", id));
    collect(tp, e, c);
}


// Collect Variable Types
void collect(current: (VarType) `int`, Collector c) {
    c.fact(current, intType());
}

void collect(current: (VarType) `char`, Collector c) {
    c.fact(current, charType());
}

void collect(current: (VarType) `bool`, Collector c) {
    c.fact(current, boolType());
}

void collect(current: (VarType) `float`, Collector c) {
    c.fact(current, floatType());
}


// Collect Parameters 
void collect(current: (Parameter) `<VarType tp> <Id id>`, Collector c) {
    c.define("<id>", variableId(), id, defType(tp));
    collect(tp, c);
}

void collect(current: (ParameterList) `<{Parameter ","}+ param_list>`, Collector c) {
    collect(param_list, c);
}

void collect(current: (ParameterDecl) `<{Parameter ";"}+ param_decl> ;`, Collector c) {
    collect(param_decl, c);
}

// Collect Function
void collect(current: (FunctionDecl) `<VarType return_tp> <Id func_name> ( <ParameterList? param_list> ) <Stmt body>`, Collector c) {
    c.enterScope(current);
        c.define("<func_name>", functionId(), func_name, defType(return_tp));
        c.setScopeInfo(c.getScope(), functionScope(), functionInfo("<func_name>"));
        for(param <- param_list) collect(param, c);
        collect(return_tp, body, c);
    c.leaveScope(current);
}

// Collect Structure
void collect(current:(StructureCreate) `struct <Id struct_name> { <ParameterDecl? param_decl> }`, Collector c) {
    c.define("<struct_name>", structId(), struct_name, defType(structType("<struct_name>"))); 
    c.enterScope(current);
        for(param <- param_decl) collect(param, c);
    c.leaveScope(current);
}

// Collect Expressions
void collect(current: (Exp) `<Id name>`, Collector c){ //Identifier 
    c.use(name, {variableId()});
}

void collect(current: (Exp) `<BooleanLiteral boolean>`, Collector c){ //Boolean 
    c.fact(current, boolType());
}

void collect(current: (Exp) `<IntegerLiteral integer>`, Collector c){ //Integer
    c.fact(current, intType());
}

void collect(current: (Exp) `<CharLiteral character>`, Collector c){ //Character
    c.fact(current, charType());
}

void collect(current: (Exp) `<FloatLiteral float>`, Collector c){ // Floating point
    c.fact(current, floatType());
}

void collect(current: (Exp) `<StringConstant string>`, Collector c){ // Strings 
    c.fact(current, stringType());
}

void collect(current: (Exp) `( <Exp e> )`, Collector c){ // Bracket
    c.fact(current, e);
    collect(e, c);
}

void collect(current: (Exp) `<Exp e1> + <Exp e2>`, Collector c){
     c.calculate("addition", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <intType(), floatType()>: return floatType();
                case <floatType(), intType()>: return floatType();
                case <floatType(), floatType()>: return floatType();
                case <boolType(), boolType()>: return boolType();
                case <stringType(), stringType()>: return stringType();
                default: {
                    s.report(error(current, "`+` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}

void collect(current: (Exp) `<Exp e1> - <Exp e2>`, Collector c) {
    c.calculate("subtraction", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <intType(), floatType()>: return floatType();
                case <floatType(), intType()>: return floatType();
                case <floatType(), floatType()>: return floatType();
                case <boolType(), boolType()>: return boolType();
                default: {
                    s.report(error(current, "`-` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}

void collect(current: (Exp) `<Exp e1> * <Exp e2>`, Collector c) {
    c.calculate("multiplication", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <intType(), floatType()>: return floatType();
                case <floatType(), intType()>: return floatType();
                case <floatType(), floatType()>: return floatType();
                case <boolType(), boolType()>: return boolType();
                default: {
                    s.report(error(current, "`*` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}

void collect(current: (Exp) `<Exp e1> / <Exp e2>`, Collector c) {
    c.calculate("division", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <intType(), floatType()>: return floatType();
                case <floatType(), intType()>: return floatType();
                case <floatType(), floatType()>: return floatType();
                case <boolType(), boolType()>: return boolType();
                default: {
                    s.report(error(current, "`/` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}
void collect(current: (Exp) `<Exp e1> \> <Exp e2>`, Collector c) {
    c.calculate("gtRelational", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return boolType();
                case <intType(), floatType()>: return boolType();
                case <floatType(), intType()>: return boolType();
                case <floatType(), floatType()>: return boolType();
                case <boolType(), boolType()>: return boolType();
                default: {
                    s.report(error(current, "`\>` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}

void collect(current: (Exp) `<Exp e1> \< <Exp e2>`, Collector c) {
     c.calculate("ltRelational", current, [e1, e2],
        AType (Solver s) { 
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return boolType();
                case <intType(), floatType()>: return boolType();
                case <floatType(), intType()>: return boolType();
                case <floatType(), floatType()>: return boolType();
                case <boolType(), boolType()>: return boolType();
                default: {
                    s.report(error(current, "`\<` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        });
      collect(e1, e2, c);
}

void collect(current: (Exp) `<Exp e> ++`, Collector c) {
    c.calculate("postIncr", current, [e],
        AType (Solver s) { 
            switch(<s.getType(e)>){
                case <intType()>: return intType();
                case <floatType()>: return floatType();
                default: {
                    s.report(error(current, "`++` not defined for %t", e));
                    return intType();
                }
            }
        });
      collect(e, c);
}

void collect(current: (Exp) `<Exp e> --`, Collector c) {
    c.calculate("postDecr", current, [e],
        AType (Solver s) {
            switch(<s.getType(e)>){
                case <intType()>: return intType();
                case <floatType()>: return floatType();
                default: {
                    s.report(error(current, "`--` not defined for %t", e));
                    return intType();
                }
            }
        });
      collect(e, c);
}

void collect(current: (Exp) `++ <Exp e>`, Collector c) {
    c.calculate("preIncr", current, [e],
        AType (Solver s) { 
            switch(<s.getType(e)>){
                case <intType()>: return intType();
                case <floatType()>: return floatType();
                default: {
                    s.report(error(current, "`++` not defined for %t", e));
                    return intType();
                }
            }
        });
      collect(e, c);
}

void collect(current: (Exp) `-- <Exp e>`, Collector c) {
    c.calculate("preDecr", current, [e],
        AType (Solver s) { 
            switch(<s.getType(e)>){
                case <intType()>: return intType();
                case <floatType()>: return floatType();
                default: {
                    s.report(error(current, "`--` not defined for %t", e));
                    return intType();
                }
            }
        });
      collect(e, c);
}

void collect(current: (Exp) `<Exp e1> = <Exp e2>`, Collector c){
  c.use(e1, {variableId()});
  c.requireEqual(e1, e2, error(current, "Lhs %t should have the same type as Rhs", e1));
  collect(e2, c);
}