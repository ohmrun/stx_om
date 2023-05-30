package stx.fail;

enum OMFailureSum{
  E_OM(str:String);
  E_OM_KeyNotFound(str:String);
  E_OM_UnexpectedEmpty;
  E_OM_UnmatchedValueType(?type:Any);
  E_OM_UnexpectedKey(str:String);
  E_OM_NotFound;
}
abstract OMFailure(OMFailureSum) from OMFailureSum to OMFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:OMFailureSum):OMFailure return new OMFailure(self);

  public function prj():OMFailureSum return this;
  private var self(get,never):OMFailure;
  private function get_self():OMFailure return lift(this);
}