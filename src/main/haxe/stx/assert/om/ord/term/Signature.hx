package stx.assert.om.ord.term;

import stx.om.sig.Signature in TSignature;

class Signature<T> extends OrdCls<TSignature<T>>{
  final delegate:Ord<T>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function comply(thiz:TSignature<T>,that:TSignature<T>):Ordered{
    return switch([thiz,that]){
      case [SigUnknown,SigUnknown]            : NotLessThan;
      case [SigPrimate(lhs),SigPrimate(rhs)]  : new stx.assert.ord.term.PrimitiveType().comply(lhs,rhs);
      case [SigCollect(lhs),SigCollect(rhs)]  : this.comply(lhs(),rhs());
      case [SigCollate(lhs),SigCollate(rhs)]  : new stx.assert.ord.term.Record(this).comply(lhs,rhs);
      case [SigPredate(lhs),SigPredate(rhs)]  : delegate.comply(lhs,rhs);
      default                                 : Ord.EnumValueIndex().comply(thiz,that);
    }
  }
}