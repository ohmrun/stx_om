package stx.om.sig.head.data;

enum Kind{
    Simple(p:PrimitiveKind);
    Composite(c:CompositeKind);
}