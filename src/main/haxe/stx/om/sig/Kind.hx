package stx.om.sig;

enum KindSum{
  Simple(p:PrimitiveType);
  Composite(c:CompositeKind);
}

abstract Kind(KindSum) from KindSum to KindSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:KindSum):Kind return new Kind(self);

  public function prj():KindSum return this;
  private var self(get,never):Kind;
  private function get_self():Kind return lift(this);

  @:from static public function fromPrimitiveType(p:PrimitiveType){
    return lift(Simple(p));
  }
}
