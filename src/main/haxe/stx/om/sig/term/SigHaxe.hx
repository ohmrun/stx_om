package stx.om.sig.term;

typedef SigHaxeEnumDef = {
  final name      : String;
  final construct : String;
  final params    : Record<SigHaxe>;
}
typedef SigHaxe = Signature<SigHaxeEnumDef>;