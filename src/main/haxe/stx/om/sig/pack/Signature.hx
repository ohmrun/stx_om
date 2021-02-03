package stx.om.sig.pack;

enum SignatureSum<T>{
  SigCollate(arr:Record<Signature<T>>);
  SigPrimate(s:PrimitiveKind);
  SigCollect(fn:Thunk<Signature<T>>);  
  SigPredate(v:T);
  SigUnknown;
}

@:using(stx.om.sig.pack.Signature.SignatureLift)
abstract Signature<TH>(SignatureSum<TH>) from SignatureSum<TH> to SignatureSum<TH>{
  public function new(self) this = self;
  static public function lift<TH>(self:SignatureSum<TH>):Signature<TH> return new Signature(self);
  

  

  public function prj():SignatureSum<TH> return this;
  private var self(get,never):Signature<TH>;
  private function get_self():Signature<TH> return lift(this);
}
class SignatureLift{
  static public function equals<T>(lhs:Signature<T>,rhs:Signature<T>,inner:Eq<T>){
    return new stx.assert.pack.eq.term.Signature(inner).applyII(lhs,rhs);
  }
  static public function fold<T,Z>(self:Signature<T>,recd: Record<Z>->Z,prim:PrimitiveKind->Z,array:Thunk<Signature<T>>->Z,fn:T->Z,n:Void->Z):Z{
    var f = fold.bind(_,recd,prim,array,fn,n);
    return switch self.prj() {
      case SigCollate(arr)  : recd(arr.map(f));
      case SigPrimate(s)    : prim(s);
      case SigCollect(t)    : array(t);
      case SigPredate(v)    : fn(v);
      case SigUnknown       : n();
    }
  }
}