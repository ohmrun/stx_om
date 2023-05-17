package stx.om.spine;

class SpineOrdTagCtr{
  static public function Spine<T>(tag:STX<Ord<Dynamic>>,inner:Ord<T>){
    return new stx.assert.om.ord.term.Spine(inner);
  }
}

