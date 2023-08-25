module Parse

import CSyntax;

import ParseTree;


public CSyntax::Program parseProgram(loc file) {
	return parse(#Program, file);
}

public CSyntax::Program parseProgram(str x, loc file) {
	return parse(#Program, x, file);
}