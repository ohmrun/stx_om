package stx.om.spine.pack;

import stx.om.spine.body.Spines;
import stx.om.spine.head.data.Spine in SpineT;
import stx.om.spine.head.data.Primitive in PrimitiveT;

@:forward abstract Spine(SpineT) from SpineT to SpineT{
  @:from static public function fromPrimitive(v:PrimitiveT):Spine{
    return SScalar(v);
  }
  static public function emptyObject():Spine{
    return SRecord([]);
  }
  static public function emptyArray():Spine{
    return SRecord([]);
  }
  static public function emptyScalar():Spine{
    return SScalar(UntypedUnknown);
  }
  @:to public function toSignature():Signature{
    return stx.om.sig.Package.Signature.fromSpine(this);
  }
  public function search(fn:Spine->Route->Kind->Option<Primitive>->Bool){
    var out   = null;
    var done  = false;
    visit(
      function(all,s,c,v){
        if(fn(all,s,c,v) && !done){
          out = {
            indicant : s,
            container : c,
            value     : v
          }
          done = false;
        }
      }
    );
    return out;
  }
  public function query(fn:Spine->Route->Kind->Option<Primitive>->Bool){
    var out = [];
    visit(
      function(all,s,c,v){
        if(fn(all,s,c,v)){
          out.push({
            indicant : s,
            container : c,
            value     : v
          });
        }
      }
    );
    return out;
  }
  public function map(fn:Spine->Spine){
    return Spines.map(this,fn);
  }
  public function visit(fn:Spine->Route->Kind->Option<Primitive>->Void){
    function handler(spine:Spine,?sel:Route){
       if(sel == null){
         sel = [];
       }
      switch(spine){
        case SRecord(arr) :
          fn(spine,sel,Composite(Offseted),null);
          for(tp in arr){
            handler(tp.snd().unbox()(),sel.append(Choice(tp.fst())));
          }
         case SArray(arr) :
           fn(spine,sel,Composite(Ordered),null);
           var idx = 0;
           for(tp in arr){
             handler(tp(),sel.append(Offset(idx)));
             idx++;
           }
         case SEmpty      : fn(spine,sel,Simple(TUntypedUnknown),null);
         case SScalar(s)  : fn(spine,sel,Simple(s.toKind()),Some(s));

      }
    }
    handler(this);
  }
  public function zipper(){
    var ls : List<Spine> = [this];
    return new Zip(Some(ls));
  }
  public function equals(that){
    return Spines.equals(this,that);
  }
  public function toAny(){
    return Spines.toAny(this);
  }
  @:from static public function fromAny(v:Dynamic):Spine{
    return switch(Type.typeof(v)){
      case TInt             : SScalar(Integer(v));
      case TFloat           : SScalar(FloatingPoint(v));
      case TBool            : SScalar(Boolean(v));
      case TObject          :
          SRecord(
            new SpineMap(Objects.tuples(v).map(
            function(tp){
              var value : Thunk<Spine> = 
                fromAny.bind(
                  tp._1
                );
              var variable : Variable<String,Thunk<Spine>> = 
                Variable.create(tp._0,value);
              return variable;
            }
          ))
          );
      case TClass( String ) : SScalar(Characters(v));
      case TClass( Array )  :
      SArray(
        v.map(
          (x) -> fromAny(x)
        )
      );
      case TNull            : SEmpty;
      case TEnum(e)         : //?
        var constructs  = std.Type.getEnumConstructs(e);
        var construct   = std.Type.enumConstructor(v);
        //trace('constructs: $constructs\nconstruct $construct');
        var output      = constructs.map(
          function(key):Variable<String,Thunk<Spine>>{
            return key == construct ?
              Variable.create(key,
                fromAny.bind(std.Type.enumParameters(v)) 
              )
            :
              Variable.create(key,function():Spine return SEmpty);
          }
        );
        SRecord(output);
      case TUnknown         : 
        null;
      case TFunction        : 
        null;
      default               :
        trace(std.Type.typeof(v));
        trace(v);
        throw 'unknown case $v'; null;
    }
  }
}