package stx.om.sig;

enum KindSum{
  Simple(p:PrimitiveKind);
  Composite(c:CompositeKind);
}

abstract Kind(KindSum) from KindSum to KindSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:KindSum):Kind return new Kind(self);

  public function prj():KindSum return this;
  private var self(get,never):Kind;
  private function get_self():Kind return lift(this);

  @:from static public function fromPrimitive(p:Primitive){
    return lift(Simple(p));
  }
}
