package stx.om.sig.pack;

enum KindSum{
  Simple(p:PrimitiveKind);
  Composite(c:CompositeKind);
}

abstract Kind(KindSum) from KindSum to KindSum{
  static public function fromPrimitive(p:Primitive){
    return Simple(p);
  }
}
