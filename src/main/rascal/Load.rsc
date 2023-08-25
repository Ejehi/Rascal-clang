module Load

import AST;
import Parse;
import Implode;


public Program load() {
	return implode(parseProgram(programPath()));
}

loc programPath() {
	return |project://rascal-clang/src/resources/test.tap|;
}
