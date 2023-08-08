module CSyntax

extend CLex;

// A Program must consist of one or more Statements
start syntax Program = statement: Stmt*;

syntax Stmt = expression: Exp ";"
            | declaration: Declaration ";"
            | block: "{" Stmt* "}"
            | returnKeyword: "return" Exp? ";"
            | breakKeyword: "break" ";"
            | continueKeyword: "continue" ";"
            | forLoop: "for" "(" Exp? ";" Exp? ";" Exp? ")" Stmt
            | ifStmt: "if" "(" Exp ")" Stmt
            | ifElseStmt: "if" "(" Exp ")" Stmt "else" Stmt
            | whileLoop: "while" "(" Exp ")" Stmt
            | funcDeclStmt: FunctionDecl
            | funcCall: FunctionCall ";"
            | structureCreateStmt: StructureCreate ";"
            ;

syntax Declaration = declaration: VarType { Id "," }+ Initialize?;

syntax Initialize = initialization: "=" Exp;

syntax VarType = integer: "int"
                | character: "char"
                | boolean: "bool"
                | \void: "void"
                | \float: "float"
                ;


syntax Parameter = param: VarType? Exp;
syntax ParameterList = paramlist: {Parameter ","}+;
syntax ParameterDecl = paramdecl: {Parameter ";"}+ ";";

syntax FunctionDecl = funcdecl: VarType Id "(" ParameterList? ")" Stmt;
syntax FunctionCall = funccall: Id "(" ParameterList? ")";

syntax StructureCreate = struct_create: "struct" Id "{" ParameterDecl? "}";

// Expressions
syntax Exp 
            = identifier: Id
            | int_constant: IntegerLiteral
            | float_constant: FloatLiteral
            | bool_constant: BooleanLiteral
            | char_constant: CharLiteral
            | string_constant: StringConstant
            | bracket \bracket: "(" Exp ")"
            > left ( post_incr: Exp "++" | post_decr: Exp "--" )
            > right ( pre_incr: "++" Exp | pre_decr: "--" Exp)
            > left ( mul: Exp "*" Exp | div: Exp "/" Exp )
            > left ( add: Exp "+" Exp | sub: Exp "-" Exp )
            > left ( gt: Exp "\>" Exp | lt: Exp "\<" Exp )
            > right (assign: Exp "=" Exp)
            ;
