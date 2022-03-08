package stx.assert.pack.eq.term;

import stx.om.core.Record in RecordT;

class Record<T> implements EqApi<RecordT<T>> extends Clazz{
  public var inner(default,null):Eq<T>;
  public function new(inner){
    super();
    this.inner = inner;
  }
  public function comply(a:RecordT<T>,b:RecordT<T>):Equaled{
    return Eq.Cluster(
      Eq.Anon(
        (lhs:Field<Thunk<T>>,rhs:Field<Thunk<T>>) -> Eq.String().comply(lhs.fst(),rhs.fst()) && inner.comply(lhs.snd()(),rhs.snd()())
      )
    ).comply(a.prj(),b.prj());
  }
}
