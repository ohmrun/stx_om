package stx.om.sig.pack.suit.signature.cases;

class SignatureEq implements EqApi<Signature> extends Clazz{
  public function applyII(a:Signature,b:Signature):Equaled{
    return switch [a,b] {
      case [SigRecord(arr0),SigRecord(arr1)]:
        arr0.equals(arr1,equals);
      case [SigScalar(s0),SigScalar(s1)] if (std.Type.enumEq(s0.prj(),s1.prj())) : 
        true;
      case [SigArray(fn0),SigArray(fn1)] : 
        applyII(fn0(),fn1());
      case [SigUnknown,SigUnknown] : 
        true;
      default : 
        false;
    }
  }
}
