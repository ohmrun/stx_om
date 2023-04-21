package stx.assert.om.comparable;

import stx.om.spine.Spine in SpineT;

class Spine<T> extends ComparableCls<SpineT<T>>{
  public final inner : Comparable<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function eq(){
    return new stx.assert.om.eq.term.Spine(inner.eq()).toEqApi();
  }
  public function lt(){
    return new stx.assert.om.ord.term.Spine(inner.lt()).toOrdApi();
  }
}