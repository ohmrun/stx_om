package stx.om.core;

enum SectionSum{
  Ordinal(int:Int);
  Nominal(str:String);
}

abstract Section(SectionSum) from SectionSum to SectionSum{
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
    return Ordinal(int);
  }
  @:from static public function fromString(str:String):Section{
    return Nominal(str);
  }
  public function toString(){
    return switch(this){
      case Nominal(str) : str;
      case Ordinal(i)   : '[$i]';
    }
  }
  @:op(A==A)
  public function equals(r:Section):Bool{
    var l = this;
    return switch([l,r]){
      case [Nominal(l),Nominal(r)]  : l == r;
      case [Ordinal(l),Ordinal(r)]  : l == r;
      default                       : false;
    }
  }
}