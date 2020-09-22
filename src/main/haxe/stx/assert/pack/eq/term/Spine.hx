package stx.assert.pack.eq.term;

import stx.assert.pack.eq.term.Record in RecordEq;

import stx.om.spine.pack.Spine in SpineT;

class Spine<T> implements EqApi<SpineT<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }

  public function applyII(a:SpineT<T>,b:SpineT<T>):Equaled{
    return switch([a,b]){
      case [Primate(PBool(b0)),Primate(PBool(b1))]                  : b0 == b1;
      case [Primate(PInt(b0)),Primate(PInt(b1))]                    : b0 == b1;
      case [Primate(PFloat(b0)),Primate(PFloat(b1))]                : b0 == b1;
      case [Primate(PString(b0)),Primate(PString(b1))]              : b0 == b1;
      case [Collate(arr0),Collate(arr1)]                            : new RecordEq(this).applyII(arr0,arr1);
      case [Collect(arr0),Collect(arr1)]                            : 
        Eq.Array(
          Eq.Anon(
            (lhs:Thunk<SpineT<T>>,rhs:Thunk<SpineT<T>>) -> this.applyII(lhs(),rhs())
          )
        ).applyII(arr0,arr1);
      case [Unknown,Unknown]                                        : AreEqual;
      case [Predate(lhs),Predate(rhs)]                              : inner.applyII(lhs,rhs);
      default                                                       : NotEqual;
    } 
  } 
}