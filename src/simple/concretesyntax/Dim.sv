grammar simple:concretesyntax;

--Unit Dimension Nonterminals
nonterminal Length with unparse, ast<ast:Dim>;
nonterminal Time with unparse, ast<ast:Dim>;
nonterminal Mass with unparse, ast<ast:Dim>;

--Dimensional Structure Nonterminals
nonterminal DimExpr with unparse, ast<ast:Dim>;
nonterminal DimMatched with unparse, ast<ast:Dim>;
nonterminal DimUnMatched with unparse, ast<ast:Dim>;
nonterminal Dim with unparse, ast<ast:Dim>;


{- 
	> Breaking up the dimensions will possibly help us with type-checking
	> Will allow us to add the type to a list...?
-}

--Unit Dimensions-----------------------------------------------------------
concrete productions t::Time
| unit::'time' { t.unparse = "time";
		t.ast = ast:timeRef(ast:dimName(unit.lexeme)); }

| unit::'hr' { t.unparse = "hr";
		t.ast = ast:timeRef(ast:dimName(unit.lexeme));}

concrete productions l::Length
| unit::'length' { l.unparse = "length";
		l.ast = ast:lengthRef(ast:dimName(unit.lexeme));}

| unit::'km' { l.unparse = "km";
		l.ast = ast:lengthRef(ast:dimName(unit.lexeme));}

concrete productions m::Mass
| unit::'mass' { m.unparse = "mass";
		m.ast = ast:massRef(ast:dimName(unit.lexeme));}

| unit::'kg' { m.unparse = "kg";
		m.ast = ast:massRef(ast:dimName(unit.lexeme)); }


--Dimension Structures------------------------------------------------------

--Dim
concrete productions d::Dim
| '[' de::DimExpr ']' { d.unparse = "[" ++ de.unparse ++ "]";
			d.ast = ast:dimensionalInfo(de.ast); }

(dimNone) | { d.unparse = "";
		d.ast = ast:dimskip();}


--DimExpr
concrete productions d::DimExpr
| d1::DimMatched { d.unparse = d1.unparse;
			d.ast = d1.ast; }

| d1::DimUnMatched { d.unparse = d1.unparse;
			d.ast = d1.ast; }

--DimMatched
concrete productions d::DimMatched
| l::Length { d.unparse = l.unparse;
		d.ast = l.ast; }

| t::Time	{ d.unparse = t.unparse;
		d.ast = t.ast; }

| m::Mass	{ d.unparse = m.unparse;
		d.ast = m.ast; }

| d1::DimMatched op::'^' i::term:IntegerLiteral { d.unparse = d1.unparse ++ op.lexeme ++ i.lexeme;
					   d.ast = ast:dimPower(d1.ast, ast:intLit(loc(i.filename, i.line, i.column), i.lexeme)); }

| d1::DimMatched '^' '-' i::term:IntegerLiteral { d.unparse = d1.unparse ++ "^-" ++ i.lexeme;
					       d.ast = ast:dimNegPower(d1.ast,ast:intLit(loc(i.filename, i.line, i.column), i.lexeme)); }

--DimUnMatched
concrete production DimMul
d::DimUnMatched ::= d1::DimExpr op::'*' d2::DimExpr 
{ 
	d.unparse = d1.unparse ++ op.lexeme ++ d2.unparse;
	d.ast = ast:dimMul(d1.ast,d2.ast); 
}
