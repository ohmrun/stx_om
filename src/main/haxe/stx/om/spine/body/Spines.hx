package stx.om.spine.body;

class Spines{
  static public function map(spine:Spine,fn:Spine->Spine):Spine{
    function handler(spine:Spine):Spine{
      return switch(spine){
        case SRecord(arr) :
          fn(
            SRecord(
              arr.map(handler)
            )
          );
         case SArray(arr) :
           fn(
              SArray(
                cast arr.map(
                  (thk:Thunk<Spine>) -> {
                    return () -> handler(thk());
                  }
                )
              )
           );
         case SEmpty      : fn(SEmpty);
         case SScalar(s)  : fn(SScalar(s));
      }
    }
    return handler(spine);
  }
  static public function equals(thiz:Spine,that:Spine){
    return switch([thiz,that]){
      case [SScalar(Boolean(b0)),SScalar(Boolean(b1))]                    : b0 == b1;
      case [SScalar(Integer(b0)),SScalar(Integer(b1))]                    : b0 == b1;
      case [SScalar(FloatingPoint(b0)),SScalar(FloatingPoint(b1))]        : b0 == b1;
      case [SScalar(Characters(b0)),SScalar(Characters(b1))]              : b0 == b1;
      case [SRecord(arr0),SRecord(arr1)]:
        arr0.equals(arr1,equals);
      case [SArray(arr0),SArray(arr1)]:
        var ok = arr0.length == arr1.length;
        if(ok){
          for(a in arr0) {
            var ok0 = false;
            for(b in arr1){
                ok = equals(a(),b());
              if(!ok){
                break;
              }
            }
          }
        }
        ok;
      case [SEmpty,SEmpty]: true;
      default: false;
    }
  }
  static public function toAny(spine:Null<Spine>):Any{
    return switch(spine){
      case SRecord(arr)        :
        var out : Dynamic = {};
        for (tp in arr){
          var l = tp.fst().toString();
          var r = toAny(tp.snd().unbox()());
          Reflect.setField(out,l,r);
        }
        out;
      case SScalar(FloatingPoint(n))    : n;
      case SScalar(Boolean(b))          : b;
      case SScalar(Integer(n))          : n;
      case SScalar(UntypedUnknown)      : null;
      case SScalar(Characters(s))       : s;
      case SArray(arr)         :
        var out = [];
        for(tp in arr){
          var v = tp();
          out.push(toAny(v));
        }
        out;
      case SEmpty                       : null;
      case null : null;
    }
  }
}