package stx.om.spine;

class SpineComparableTagCtr{
  static public function Spine<T>(tag:STX<Comparable<Dynamic>>,inner:Comparable<T>){
    return new stx.assert.om.comparable.Spine(inner);
  }
}