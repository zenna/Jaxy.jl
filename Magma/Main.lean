import Magma

inductive UnaryOp where 
  | Neg
  | Not
  deriving Repr

inductive BinaryOp where
  | Add
  | Sub
  | Mul
  | Div
  deriving Repr

def Var := Nat

inductive Handler where
  | ret (x: Var) (e: Expr)
  | opmap (x: Var) (e : Expr) (h: Handler)
  deriving Repr

inductive Expr where
  | app (fn : Expr) (arg : Expr)
  | letE (declName : Name) (value : Expr) (body : Expr)
  | Lett (a: Expr) (b: Expr) (c: Expr)
  | handle (h : Handler) (e : Expr) 
  deriving Repr

def x := 3

#eval UnaryOp.Neg

def main : IO Unit :=
  IO.println s!"Hello, {hello}!"
