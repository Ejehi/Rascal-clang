module Implode

import CSyntax;

import AST;

import ParseTree;

public AST::Program implode(CSyntax::Program pt) {
	return implode(#AST::Program, pt);
}
