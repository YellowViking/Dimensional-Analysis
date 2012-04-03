grammar simple:abstractsyntax;

synthesized attribute enum :: Integer;

nonterminal DimName with pp, name;
nonterminal Dim with pp, env, defs, errors, enum;

abstract production dimName
n::DimName ::= s::String
{
  n.name = s;
  n.pp = text(s);
}

abstract production timeRef  
e::Dim ::= d::DimName
{
  e.pp = d.pp;
  e.enum = 1;
}

abstract production lengthRef  
e::Dim ::= d::DimName
{
  e.pp = d.pp;
  e.enum = 2;
}

abstract production massRef  
e::Dim ::= d::DimName
{
  e.pp = d.pp;
  e.enum = 3;
}

--

abstract production dimMul
e::Dim ::= d1::Dim d2::Dim
{
	e.pp = dimexproperator(d1.pp, "*", d2.pp);
}

abstract production dimPower
e::Dim ::= d1::Dim i::Expr
{
	e.pp = dimexproperator(d1.pp, "^", i.pp);
}

abstract production dimNegPower
e::Dim ::= d1::Dim i::Expr
{
	e.pp = dimexproperator(d1.pp, "^-", i.pp);
}

function diminfooperator
Document ::= p1::String de::Document p2::String
{ 
	return cat(cat(text(p1), de), text(p2));
}

function dimexproperator
Document ::= d1::Document op::String d2::Document
{ 
	return cat(cat(d1, text(op)), d2);
}

abstract production dimskip
e::Dim ::= 
{
	e.pp = semi();
}


abstract production dimensionalInfo
e::Dim ::= de::Dim
{
	e.pp = diminfooperator("[", de.pp, "]");
	e.enum = de.enum;
	e.errors := [];
}
