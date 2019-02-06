package stx.om.spine.pack;

import stx.om.spine.Package.Section;


@:forward abstract Route(ReadOnlyArray<Section>) from ReadOnlyArray<Section> to ReadOnlyArray<Section>{
  static public function unit():Route{
    return [];
  }
  @:from static public function fromArray(arr:Array<Section>){
    var a : ReadOnlyArray<Section> = arr;
    return new Route(a);
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
            case Offset(i):   '[$i]';
            case Choice(str): '.$str';
          }
        }
      ).join("");
      switch(fst){
        case Choice(str) : '$str$tail';
        case Offset(idx) : '[$idx]$tail';
      }
    }
  }
  public function unbox():Array<Section>{
    return this.toArray();
  }
}
