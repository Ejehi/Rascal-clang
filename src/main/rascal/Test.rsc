module Test

import CSyntax;
extend Checker;
extend analysis::typepal::TestFramework;
import ParseTree;

TModel clangTModelFromTree(Tree pt){
    return collectAndSolve(pt);
}

TModel clangTModelFromStr(str text){
    pt = parse(#start[Program], text).top;
    return clangTModelFromTree(pt);
}

bool clangTests() {
     return runTests([|project://rascal-clang/src/main/rascal/tests.ttl|], 
                     #Program, clangTModelFromTree);
}