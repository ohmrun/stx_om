package stx.om.spine;

enum SpineSum<T>{
  Collate(arr:Record<Spine<T>>);
  Primate(sc:Primitive);
  Collect(arr:Array<Thunk<Spine<T>>>);
  Predate(v:T);
  OSEmpty;
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
}
class SpineLift{
  static public function mod<T,U>(spine:Spine<T>,fn:Spine<T>->Spine<U>):Spine<U>{
    function handler(spine:Spine<T>):Spine<U>{
      return switch(spine){
        case Collate(arr)   : Collate(arr.map(handler));
        case Collect(arr)   : Collect(arr.map((thk:Thunk<Spine<T>>) -> () -> handler(thk())));
         case OSEmpty       : fn(OSEmpty);
         case Primate(s)    : fn(Primate(s));
         case Predate(t)    : fn(Predate(t));
      }
    }
    return handler(spine);
  }
  // static public function equals<T>(thiz:Spine<T>,that:Spine<T>,with:T->T->Bool):Bool{
  //   return new stx.om.spine.pack.suit.spine.cases.SpineEq().applyII(thiz,that).ok();
  // }
}