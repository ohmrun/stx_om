package stx.assert.om.ord.term;

import stx.om.spine.Spine in TSpine;

class Spine<T> extends OrdCls<TSpine<T>>{
  final delegate:Ord<T>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function comply(thiz:TSpine<T>,that:TSpine<T>):Ordered{
    return switch([thiz,that]){
      case [Unknown,Unknown]            : NotLessThan;
      case [Primate(lhs),Primate(rhs)]  : Ord.Primitive().comply(lhs,rhs);
      case [Collect(lhs),Collect(rhs)]  : Ord.Cluster(Ord.Anon((l:Void -> TSpine<T>,r:Void -> TSpine<T>) -> this.comply(l(),r()))).comply(lhs,rhs);
      case [Collate(lhs),Collate(rhs)]  : new stx.assert.ord.term.Record(this).comply(lhs,rhs);
      case [Predate(lhs),Predate(rhs)]  : delegate.comply(lhs,rhs);
      default                           : Ord.EnumValueIndex().comply(thiz,that);
    }
  }
}