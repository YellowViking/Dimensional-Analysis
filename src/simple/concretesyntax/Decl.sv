grammar simple:concretesyntax;

{--
 - A statement declaring a variable and its type.
 -}
nonterminal Decl with unparse, ast<ast:Decl>;

concrete productions d::Decl
 | te::TypeExpr id::term:Id ';'  { d.unparse = te.unparse ++ " " ++ id.lexeme ++ "; \n";
                                   d.ast = ast:decl(te.ast, name(id)); }

{--
 - A concrete expression denoting a type
 -}
nonterminal TypeExpr with unparse, ast<ast:TypeExpr>;

concrete productions t::TypeExpr
 | dim::Dim 'Integer'  { t.unparse = dim.unparse ++ " Integer";
				t.ast = case dim of
					dimNone() -> ast:typeExprInteger()
					|_-> ast:typeExprDimInteger(dim.ast)
				end; }

 | dim::Dim 'Float'    { t.unparse = dim.unparse ++ " Float";
				t.ast = case dim of
					dimNone() -> ast:typeExprFloat()
					|_-> ast:typeExprDimFloat(dim.ast)
				end; }

 | 'Boolean'  { t.unparse = "Boolean";
                t.ast = ast:typeExprBoolean(); }
