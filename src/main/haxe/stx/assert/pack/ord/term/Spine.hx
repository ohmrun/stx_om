package stx.assert.pack.ord.term;

import stx.om.spine.pack.Spine in SpineT;

class Spine<T> implements OrdApi<Spine<T>>{
  public var inner(default,null):Ord<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function applyII(lhs:Spine<T>,rhs:Spine<T>):Ordered{
    return switch([lhs,rhs]){
      case [Unknown,Unknown]            : NotLessThan;
      case [Primate(lhs),Primate(rhs)]  : Ord.Primitive().applyII(lhs,rhs);
      case [Collect(lhs),Collect(rhs)]  : Ord.Array(this).applyII(lhs,rhs);
      case [Collate(lhs),Collate(rhs)]  : Record._.ord(this).applyII(lhs,rhs);
      case [Predate(lhs),Predate(rhs)]  : inner.apply(lhs,rhs);
      case [Unknown,Unknown]            : NotLessThan;
      default                           : Ord.Int().applyII(EnumValue.pure(lhs).index(),EnumValue.pure(rhs).index());
    }
  }
}