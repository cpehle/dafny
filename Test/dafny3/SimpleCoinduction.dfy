codatatype Stream<T> = Cons(head: T, tail: Stream);
codatatype IList<T> = Nil | ICons(head: T, tail: IList);

// -----------------------------------------------------------------------

copredicate Pos(s: Stream<int>)
{
  s.head > 0 && Pos(s.tail)
}

function Up(n: int): Stream<int>
{
  Cons(n, Up(n+1))
}

function Inc(s: Stream<int>): Stream<int>
{
  Cons(s.head + 1, Inc(s.tail))
}

ghost method {:induction false} UpLemma(k: nat, n: int)
  ensures Inc(Up(n)) ==#[k] Up(n+1);
{
  if (k != 0) {
    UpLemma(k-1, n+1);
  }
}

comethod {:induction false} CoUpLemma(n: int)
  ensures Inc(Up(n)) == Up(n+1);
{
  CoUpLemma(n+1);
}

ghost method UpLemma_Auto(k: nat, n: int)
  ensures Inc(Up(n)) ==#[k] Up(n+1);
{
}

comethod CoUpLemma_Auto(n: int)
  ensures Inc(Up(n)) == Up(n+1);
{
}

// -----------------------------------------------------------------------

function Repeat(n: int): Stream<int>
{
  Cons(n, Repeat(n))
}

comethod RepeatLemma(n: int)
  ensures Inc(Repeat(n)) == Repeat(n+1);
{
}

// -----------------------------------------------------------------------

copredicate True(s: Stream)
{
  True(s.tail)
}

comethod AlwaysTrue(s: Stream)
  ensures True(s);
{
  AlwaysTrue(s.tail);  // WHY does this not happen automatically? (Because 's' is not quantified over)
}

copredicate AlsoTrue(s: Stream)
{
  AlsoTrue(s)
}

comethod AlsoAlwaysTrue(s: Stream)
  ensures AlsoTrue(s);
{
  // AlsoAlwaysTrue(s);  // here, the recursive call is not needed, because it uses the same 's', so 's' does not need to be quantified over
}

// -----------------------------------------------------------------------

function Append(M: IList, N: IList): IList
{
  match M
  case Nil => N
  case ICons(x, M') => ICons(x, Append(M', N))
}

function zeros(): IList<int>
{
  ICons(0, zeros())
}

function ones(): IList<int>
{
  ICons(1, ones())
}

copredicate AtMost(a: IList<int>, b: IList<int>)
{
  match a
  case Nil => true
  case ICons(h,t) => b.ICons? && h <= b.head && AtMost(t, b.tail)
}

comethod ZerosAndOnes_Theorem0()
  ensures AtMost(zeros(), ones());
{
}

comethod ZerosAndOnes_Theorem1()
  ensures Append(zeros(), ones()) == zeros();
{
}
