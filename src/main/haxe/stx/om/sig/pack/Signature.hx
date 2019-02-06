package stx.om.sig.pack;

import stx.om.sig.body.Signatures;
import stx.om.sig.head.data.Signature in TSignature;

abstract Signature(TSignature) from TSignature to TSignature{
  @:from static public function fromSpine(spine:Spine):Signature{
    //trace(spine);
    return switch(spine){
      case SRecord(arr) : SigRecord(arr.map(fromSpine));
      case SScalar(sc)  : SigScalar(sc.toKind());
      case SArray(arr)  :
        SigArray(
          function(){
            var out = SigUnknown;
            for(v in arr){
              var val = v();
              switch(val){
                case SEmpty:
                default :
                  out = fromSpine(val);
                  break;
              }
            }
            return out;
          }
        );
      case SEmpty       :
        SigUnknown;
    }
  }
  @:from static public function fromAny(v:Dynamic):Signature{
    //trace('Signature#fromAny $v ${Type.typeof(v)}');
    return switch(Type.typeof(v)){
      case TInt             : SigScalar(TInteger);
      case TFloat           : SigScalar(TFloatingPoint);
      case TBool            : SigScalar(TBoolean);
      case TObject          :
        SigRecord(
          __.core()
            .object(v)
            .fields()
            .map(
              (fld:Field<Dynamic>) -> fld.map(
                (v) -> {
                  return () -> fromAny(v);
                }
              )
            ).fold(
              Record.reduct,
              new Record()
            )
        );
      case TClass( String ) : SigScalar(TCharacters);
      case TClass( Array )  :
        var arr : Array<Dynamic> = cast v;
        var val = v.fold(
          function (next,memo:Option<Dynamic>){
            return memo.orElse(
              () -> next == null ? None : Some(next)
            );
          },
          None
        );
        SigArray(
          switch(val){
            case Some(v)  : () -> fromAny(v);
            case None     : () -> SigUnknown;
          }
        );
      default               : SigUnknown;
    }
  }
  public function fold<Z>(v:Z,fn:Z->Signature->Z):Z{
    return Signatures.fold(this,v,fn);
  }
  public function equals(that){
    return Signatures.equals(this,that);
  }
}
