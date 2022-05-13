package stx.assert.om.ord.term;

import stx.om.sig.PrimitiveKind in TPrimitiveKind;

class PrimitiveKind extends OrdCls<TPrimitiveKind>{
  public function new(){}
  public function comply(lhs:TPrimitiveKind,rhs:TPrimitiveKind){
    return switch([lhs,rhs]){
      case [TUntypedUnknown,TUntypedUnknown]  : NotLessThan;
      case [TBoolean,TBoolean]                : NotLessThan;
      case [TInteger,TInteger]                : NotLessThan;
      case [TFloatingPoint,TFloatingPoint]    : NotLessThan;
      case [TCharacters,TCharacters]          : NotLessThan;
      default                                 : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}