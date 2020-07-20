package stx.om.sig.head.data;

//import fig.body.PrimitiveKind in PrimitiveKindA;
import stx.om.sig.pack.Signature in SignatureA;
//https://github.com/purescript/purescript-generics/blob/master/docs/Data/Generic.md

enum Signature{
  SigRecord(arr:Record<SignatureA>);
  SigScalar(s:PrimitiveKind);
  SigArray(fn:Thunk<SignatureA>);  
  SigUnknown;
}
