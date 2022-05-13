package stx.om.sig;

enum PrimitiveKindSum{
  TUntypedUnknown;
  TBoolean;
  TInteger;
  TFloatingPoint;
  TCharacters;
}

abstract PrimitiveKind(PrimitiveKindSum) from PrimitiveKindSum to PrimitiveKindSum{
  public function new(self){
    this = self;
  }
  @:from static public function fromPrimitive(p:Primitive):PrimitiveKind{
    return switch p {
      case PNull                      : TUntypedUnknown;
      case PBool(_)                   : TBoolean;
      case PSprig(Byteal(NInt(_)))    : TInteger;
      case PSprig(Byteal(NInt64(_)))  : TInteger;
      case PSprig(Byteal(NFloat(_)))  : TFloatingPoint;
      case PSprig(Textal(_))          : TCharacters;
    }
  }
  
  public function prj():PrimitiveKindSum{
    return this;
  }
}