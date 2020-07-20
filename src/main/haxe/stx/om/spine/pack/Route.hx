package stx.om.spine.pack;

import stx.om.spine.Package.Section;

@:forward abstract Route(Array<Section>) from Array<Section> to Array<Section>{
  static public function unit():Route{
    return [];
  }
  @:from static public function fromArray(arr:Array<Section>){
    return new Route(arr);
  }
  @:arrayAccess public function get(v:Int):Section{
    return this[v];
  }
  public function new(self){
    this = self;
  }
  public function toString(){
    var fst = this.head();
    return if(fst == null){
      '';
    }else{
      var rst   = this.tail();
      var tail  = rst.map(
        function(x){
          return switch(x){
            case Ordinal(i):   '[$i]';
            case Nominal(str): '.$str';
          }
        }
      ).join("");
      switch(fst){
        case Some(Nominal(str))  : '$str$tail';
        case Some(Ordinal(idx))  : '[$idx]$tail';
        case None               : '$tail'; 
      }
    }
  }
  public function prj():Array<Section>{
    return this;
  }
}
