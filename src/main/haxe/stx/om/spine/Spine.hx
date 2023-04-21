package stx.om.spine;

enum SpineSum<T = tink.core.Noise>{
  Unknown;
  Predate(v:T);//TODO this order changes depending on what T is, right? Pre-date vs predate
  Primate(sc:Primitive);
  Collate(arr:Record<Spine<T>>);
  Collect(arr:Cluster<Void -> Spine<T>>);
}
@:using(stx.om.spine.Spine.SpineLift)
@:forward abstract Spine<T = tink.core.Noise>(SpineSum<T>) from SpineSum<T> to SpineSum<T>{
  @:from static public function fromPrimitive<T>(v:PrimitiveDef):Spine<T>{
    return Primate(v);
  }
  @:noUsing static public function record<T>():Spine<T>{
    return Collate(Cluster.unit());
  }
  @:noUsing static public function array<T>():Spine<T>{
    return Collect([]);
  }
  // public function zipper(){
  //   var ls : LinkedList<Spine<T>> = Cons(this,Nil);
  //   return new Zip(Some(ls));
  // }
  public function unbox():SpineSum<T>{
    return this;
  }
  public function access(key:String):Option<Spine<T>>{
    return switch(this){
      case Collate(arr) : arr.get(key).map( _ -> _ () );
      default           : None;
    }
  }
}
class SpineLift{
  static public function toJson<T>(self:Spine<T>){
    function rec(v:Spine<T>):Any{
      trace(v);
      return switch(v){
        case Unknown              : null;
        case Predate(v)           : v;
        case Primate(PBool(b))    : b;
        case Primate(p)   : p.toAny();
        case Collate(arr) : 
          final obj : Dynamic = {};
          for(x in arr){
            Reflect.setField(obj,x.fst(),rec(x.snd()()));
          }
          obj;
        case Collect(arr) : 
          arr.map((x:Void->Spine<T>) -> rec(x()));
      }
    }
    return haxe.Json.stringify(rec(self)," ");
  }
  // static public function traverse<T,Ti>(fn:T->Ti):Y<Spine<T>,Expr<Ti>>{
  //   return function rec(y:Y<Spine<T>,Expr<Ti>>):Spine<T>->Expr<Ti>{
  //     var fn = rec(y);
  //     return function(spine:Spine<T>){
  //       return switch(spine){
  //         case Collate(arr)	: 
  //           Group(arr.prj().map(
  //             (field) -> Cons(Label(field.key),Cons(fn(field.val()),Nil))
  //           ).fold(
  //             (n,m:LinkedList<Expr<Ti>>) -> m.concat(n),
  //             Nil
  //           ));
  //         default           : null;
  //         case Primate(sc)	: //???
  //         // case Collect(arr)	:
  //         // case Predate(v)		:
  //         // case Unknown			:
  //       }
  //     }
  //   }
  // }
  static public function mod<T,U>(spine:Spine<T>,fn:Spine<T>->Spine<U>):Spine<U>{
    function handler(spine:Spine<T>):Spine<U>{
      return switch(spine){
        case Collate(arr)   : Collate(arr.map(handler));
        case Collect(arr)   : Collect(arr.map((thk:Void -> Spine<T>) -> () -> handler(thk())));
        case Unknown        : fn(Unknown);
        case Primate(s)     : fn(Primate(s));
        case Predate(t)     : fn(Predate(t));
      }
    }
    return handler(spine);
  }
  static public function equals<T>(thiz:Spine<T>,that:Spine<T>,with:Eq<T>){
    return new stx.assert.om.eq.term.Spine(with).comply(thiz,that);
  }
  static public function fold<T,Z>(self:Spine<T>,unknown:Void->Z,primate:Primitive->Z,collect:Cluster<Z>->Z,collate:Record<Z>->Z,predate:T->Z){
    var f = fold.bind(_,unknown,primate,collect,collate,predate);
    return switch(self){
      case Unknown        : unknown();
      case Primate(sc)    : primate(sc);
      case Collect(arr)   : collect(arr.map((x) -> f(x())));
      case Collate(arr)   : collate(arr.map(f));
      case Predate(v)     : predate(v); 
    }
  }
  static public function toSig<T,Z>(self:Spine<T>,primate:Primitive->Signature<Z>,collect:Spine<T>->Signature<Z>->Signature<Z>,collect_unit:Signature<Z>,collate:Record<Signature<Z>>->Signature<Z>,predate:T->Signature<Z>):Signature<Z>{
    var f = toSig.bind(_,primate,collect,collect_unit,collate,predate);
    return switch(self){
      case Unknown        : SigUnknown;
      case Primate(sc)    : primate(sc);
      case Collect(arr)   : arr.lfold((next,memo)->collect(next(),memo),collect_unit);
      case Collate(arr)   : collate(arr.map(f));
      case Predate(v)     : predate(v);
    }
  }
}