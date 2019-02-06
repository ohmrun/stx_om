
package stx.om.spine.pack;

import stx.om.spine.head.Data.Section in SectionT;

abstract Section(SectionT) from SectionT to SectionT{
  public function new(self){
    this = self;
  }
  static public function int(i){
    return fromInt(i);
  }
  static public function string(s){
    return fromString(s);
  }
  @:from static public function fromInt(int:Int):Section{
    return Offset(int);
  }
  @:from static public function fromString(str:String):Section{
    return Choice(str);
  }
  public function toString(){
    return switch(this){
      case Choice(str) : str;
      case Offset(i)   : '[$i]';
    }
  }
  @:op(A==A)
  public function equals(r:Section):Bool{
    var l = this;
    return switch([l,r]){
      case [Choice(l),Choice(r)] : l == r;
      case [Offset(l),Offset(r)] : l == r;
      default                  : false;
    }
  }
}