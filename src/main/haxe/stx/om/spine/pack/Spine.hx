package stx.om.spine.pack;

enum SpineSum<T>{
  Unknown;
  Primate(sc:Primitive);
  Collect(arr:Array<Thunk<Spine<T>>>);
  Collate(arr:Record<Spine<T>>);
  Predate(v:T);
}
@:forward abstract Spine<T>(SpineSum<T>) from SpineSum<T> to SpineSum<T>{
  @:from static public function fromPrimitive<T>(v:PrimitiveDef):Spine<T>{
    return Primate(v);
  }
  @:noUsing static public function record<T>():Spine<T>{
    return Collate([]);
  }
  @:noUsing static public function array<T>():Spine<T>{
    return Collect([]);
  }
  public function zipper(){
    var ls : LinkedList<Spine<T>> = Cons(this,Nil);
    return new Zip(Some(ls));
  }
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
        case Collect(arr)   : Collect(arr.map((thk:Thunk<Spine<T>>) -> () -> handler(thk())));
        case Unknown        : fn(Unknown);
        case Primate(s)     : fn(Primate(s));
        case Predate(t)     : fn(Predate(t));
      }
    }
    return handler(spine);
  }
  static public function equals<T>(thiz:Spine<T>,that:Spine<T>,with:Eq<T>){
    return new stx.assert.pack.eq.term.Spine(with).applyII(thiz,that);
  }
}