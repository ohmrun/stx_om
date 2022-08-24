package stx.om.sig;

class SignatureCtr extends Clazz{
  public function Unknown<T>():Signature<T>{
    return SigUnknown;
  }
  public function Primate<T>(fn:CTR<PrimitiveTypeCtr,PrimitiveType>):Signature<T>{
    return SigPrimate(fn(new PrimitiveTypeCtr()));
  }
  public function Collect<T>(fn:CTR<SignatureCtr,Signature<T>>):Signature<T>{
    return SigCollect(() -> fn(this));
  }
  public function Collate<T>(fn:CTR<SignatureCtr,Map<String,Signature<T>>>):Signature<T>{
    return SigCollate(Record.fromMap(fn(this)));
  }
  public function Predate<T>(self:T):Signature<T>{
    return SigPredate(self);
  }
}
enum SignatureSum<T>{
  SigUnknown;
  SigPrimate(s:PrimitiveType);
  SigCollect(fn:Void -> Signature<T>);  
  SigCollate(arr:Record<Signature<T>>);
  SigPredate(v:T);
}

@:using(stx.om.sig.Signature.SignatureLift)
abstract Signature<TH>(SignatureSum<TH>) from SignatureSum<TH> to SignatureSum<TH>{
  public function new(self) this = self;
  @:noUsing static public function lift<TH>(self:SignatureSum<TH>):Signature<TH> return new Signature(self);
  

  

  public function prj():SignatureSum<TH> return this;
  private var self(get,never):Signature<TH>;
  private function get_self():Signature<TH> return lift(this);

  //public function fromSpine<T>(self:Spine<T,)
}
class SignatureLift{
  static public function equals<T>(lhs:Signature<T>,rhs:Signature<T>,inner:Eq<T>){
    return new stx.assert.om.eq.term.Signature(inner).comply(lhs,rhs);
  }
  static public function fold<T,Z>(self:Signature<T>,recd: Record<Z>->Z,prim:PrimitiveType->Z,array:(Void ->Signature<T>)->Z,fn:T->Z,n:Void->Z):Z{
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