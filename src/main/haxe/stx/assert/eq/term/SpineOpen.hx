package stx.assert.eq.term;

using stx.Pico;
using stx.Assert;
using stx.om.Spine;

class SpineOpen<T> implements EqApi<SpineOpen<T>>{
  var inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }

  public function applyII(a:SpineOpen<T>,b:SpineOpen<T>):Equaled{
    return switch([a,b]){
      case [Primate(PBool(b0)),Primate(PBool(b1))]                  : b0 == b1;
      case [Primate(PInt(b0)),Primate(PInt(b1))]                    : b0 == b1;
      case [Primate(PFloat(b0)),Primate(PFloat(b1))]                : b0 == b1;
      case [Primate(PString(b0)),Primate(PString(b1))]              : b0 == b1;
      case [Collate(arr0),Collate(arr1)]:
        arr0.equals(arr1,this);
      case [Collect(arr0),Collect(arr1)]:
        var ok = arr0.length == arr1.length;
        if(ok){
          for(a in arr0) {
            var ok0 = false;
            for(b in arr1){
                ok = duoply(a(),b()).ok();
              if(!ok){
                break;
              }
            }
          }
        }
        ok;
      case [OSEmpty,OSEmpty]                  : AreEqual;
      case [Predate(lhs),Predate(rhs)]      : inner.applyII(lhs,rhs);
      default                                 : NotEqual;
    } 
  } 
}