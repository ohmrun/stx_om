package stx.om.sig.body;

import stx.om.sig.head.data.Signature in TSignature;

class Signatures{
  static public function equals(thiz:Signature,that:Signature){
    return switch [thiz,that] {
      case [SigRecord(arr0),SigRecord(arr1)]:
        arr0.equals(arr1,equals);
      case [SigScalar(s0),SigScalar(s1)] if (Type.enumEq(s0,s1)) : 
        true;
      case [SigArray(fn0),SigArray(fn1)] : 
        equals(fn0(),fn1());
      case [SigUnknown,SigUnknown] : 
        true;
      default : 
        false;
    }
  }
  static public function fold<Z>(sig:Signature,v:Z,fn:Z->Signature->Z):Z{
    return switch(sig){
      case SigRecord(arr) :
        var o = fn(v,SigRecord(arr));
        arr.fold(
          function(next,memo){
            var out = next.val();
            return fold(out,memo,fn);
          },
          o
        );

      case SigScalar(sc): fn(v,SigScalar(sc));
      case SigArray(fn0):
        var o = fn(v,SigArray(fn0));
        fn(o,fn0());
      case SigUnknown: fn(v,SigUnknown);
    }
  }
}
