module CLex

extend lang::std::Layout;

// Must always start with an alphabet or underscore
// Must contain one or more characters
// Should not be followed or preceeded by a character (Follow and Preceede Restriction)
// Must not be a keyword
lexical Id = ([a-z A-Z 0-9 _] !<< [a-z A-Z _] [a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9 _]) \ Keyword;

// Must be a digit
// Must be one or more digits
// Should not be followed or preceeded by a digit (Follow and Preceede Restriction)
lexical IntegerLiteral = [0-9] !<< ( "-"? [0-9]+ ) !>> [0-9];

lexical FloatLiteral = "-"? [0-9]+ "." !>> "." [0-9]+;

// String contains characters between double quotes
lexical CharLiteral = [\'] Char_Content [\'];
lexical Char_Content = [\\] ![] | ![\\\'];
lexical StringConstant = [\"] String_Content* [\"];
lexical String_Content  = ![\\ \" \n] | "\\" [\\ \"];

lexical BooleanLiteral = "true" 
                        | "false";

lexical NewLine = "\r\n" | "\r\t";

keyword Keyword 
                = "true"
                | "false"
                | "null"
                | "string"
                | "return"
                | "struct"
                | "int"
                | "float"
                | "char"
                | "bool"
                | "void"
                | "break"
                | "continue"
                | "for"
                | "if"
                | "while"
                ;