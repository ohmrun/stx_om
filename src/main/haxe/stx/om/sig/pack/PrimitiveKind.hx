package stx.om.sig.pack;

enum PrimitiveKindSum{
  TBoolean;
  TInteger;
  TFloatingPoint;
  TCharacters;
  TUntypedUnknown;
}

abstract PrimitiveKind(PrimitiveKindSum) from PrimitiveKindSum to PrimitiveKindSum{
  public function new(self){
    this = self;
  }
  @:from static public function fromPrimitive(p:Primitive):PrimitiveKind{
    return switch p {
      case PNull      : TUntypedUnknown;
      case PBool(_)   : TBoolean;
      case PInt(_)    : TInteger;
      case PFloat(_)  : TFloatingPoint;
      case PString(_) : TCharacters;
    }
  }
  public function prj():PrimitiveKindSum{
    return this;
  }
}