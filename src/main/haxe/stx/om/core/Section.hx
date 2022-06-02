package stx.om.core;

enum SectionSum{
  SIdx(int:Int);
  SKey(key:String);
}
abstract Section(SectionSum) from SectionSum to SectionSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:SectionSum):Section return new Section(self);

  public function prj():SectionSum return this;
  private var self(get,never):Section;
  private function get_self():Section return lift(this);

  @:from static public function fromString(self:String){
    return lift(SKey(self));
  }
  @:from static public function fromInt(self:Int){
    return lift(SIdx(self));
  }
}