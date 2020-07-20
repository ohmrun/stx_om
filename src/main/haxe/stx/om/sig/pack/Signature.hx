package stx.om.sig.pack;

enum SignatureSum<TH>{
  SigRecord(arr:Record<Signature<TH>>);
  SigScalar(s:PrimitiveKind);
  SigArray(fn:Thunk<Signature<TH>>);  
  SigUnknown;
  SigInject(v:TH);
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
  static public function testyWoo<TH>(os:Signature<TH>){
    return true;
  }
}