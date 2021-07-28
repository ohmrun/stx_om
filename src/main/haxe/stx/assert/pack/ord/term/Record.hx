package stx.assert.pack.ord.term;

import stx.om.core.Record in RecordT;

class Record<T> implements OrdApi<RecordT<T>>{
  public var inner(default,null):Ord<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:RecordT<T>,rhs:RecordT<T>):Ordered{
    var inner_inner = Ord.Anon(
      (lhs:Field<Thunk<T>>,rhs:Field<Thunk<T>>) -> {
        return Ord.String().comply(lhs.fst(),rhs.fst()) &&  inner.comply(lhs.snd()(),rhs.snd()());
    });
    return Ord.Array(inner_inner).comply(lhs.prj(),rhs.prj());
  }
}