package stx.om.spine;

class SpineEqTagCtr{
  static public function Spine<T>(tag:STX<Eq<Dynamic>>,inner:Eq<T>){
    return new stx.assert.om.eq.term.Spine(inner);
  }
}