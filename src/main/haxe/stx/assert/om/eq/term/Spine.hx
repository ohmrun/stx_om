package stx.assert.om.eq.term;

import stx.assert.eq.term.Record in RecordEq;

import stx.om.spine.Spine in SpineT;

class Spine<T> implements EqApi<SpineT<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }

  public function comply(a:SpineT<T>,b:SpineT<T>):Equaled{
    return switch([a,b]){
      case [Primate(PBool(b0)),Primate(PBool(b1))]                                      : b0 == b1;
      case [Primate(PSprig(Byteal(NInt(b0)))),Primate(PSprig(Byteal(NInt(b1))))]        : b0 == b1;
      case [Primate(PSprig(Byteal((b0)))),Primate(PSprig(Byteal((b1))))]                : b0 == b1;
      case [Primate(PSprig(Textal(b0))),Primate(PSprig(Textal(b1)))]                    : b0 == b1;
      case [Collate(arr0),Collate(arr1)]                            : new RecordEq(this).comply(arr0,arr1);
      case [Collect(arr0),Collect(arr1)]                            : 
        Eq.Cluster(
          Eq.Anon(
            (lhs:Void -> SpineT<T>,rhs:Void -> SpineT<T>) -> this.comply(lhs(),rhs())
          )
        ).comply(arr0,arr1);
      case [Unknown,Unknown]                                        : AreEqual;
      case [Predate(lhs),Predate(rhs)]                              : inner.comply(lhs,rhs);
      default                                                       : NotEqual;
    } 
  } 
}