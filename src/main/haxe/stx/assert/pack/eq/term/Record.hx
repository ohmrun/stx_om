package stx.assert.pack.eq.term;

import stx.om.core.Record in RecordT;

class Record<T> implements EqApi<RecordT<T>> extends Clazz{
  public var inner(default,null):Eq<T>;
  public function new(inner){
    super();
    this.inner = inner;
  }
  public function applyII(a:RecordT<T>,b:RecordT<T>):Equaled{
    return Eq.Array(
      Eq.Anon(
        (lhs:Field<Thunk<T>>,rhs:Field<Thunk<T>>) -> Eq.String().applyII(lhs.fst(),rhs.fst()) && inner.applyII(lhs.snd()(),rhs.snd()())
      )
    ).applyII(a.prj(),b.prj());
  }
}
