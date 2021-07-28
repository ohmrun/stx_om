package stx.assert.pack.eq.term;
import stx.om.sig.pack.Signature in SignatureT;

class Signature<T> implements EqApi<SignatureT<T>> extends Clazz{
  public var inner(default,null):Eq<T>;
  public function new(inner){
    super();
    this.inner = inner;
  }
  public function comply(a:SignatureT<T>,b:SignatureT<T>):Equaled{
    return switch [a,b] {
      case [SigCollate(arr0),SigCollate(arr1)]:
        arr0.equals(arr1,this);
      case [SigPrimate(s0),SigPrimate(s1)] if (std.Type.enumEq(s0.prj(),s1.prj())) : 
        true;
      case [SigCollect(fn0),SigCollect(fn1)] : 
        comply(fn0(),fn1());
      case [SigUnknown,SigUnknown] : 
        true;
      case [SigPredate(lhs),SigPredate(rhs)] : 
        this.inner.comply(lhs,rhs);
      default : 
        false;
    }
  }
}
