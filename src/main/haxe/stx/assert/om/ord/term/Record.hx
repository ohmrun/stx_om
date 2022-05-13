package stx.assert.om.ord.term;

import stx.om.core.Record in RecordT;

class Record<T> extends OrdCls<RecordT<T>>{
  final delegate:Ord<T>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function comply(lhs:RecordT<T>,rhs:RecordT<T>):Ordered{
    var delegate_delegate = Ord.Anon(
      (lhs:Field<Thunk<T>>,rhs:Field<Thunk<T>>) -> {
        return Ord.String().comply(lhs.fst(),rhs.fst()) &&  delegate.comply(lhs.snd()(),rhs.snd()());
    });
    return Ord.Cluster(delegate_delegate).comply(lhs.prj(),rhs.prj());
  }
}