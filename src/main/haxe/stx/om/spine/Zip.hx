package stx.om.spine;

abstract Zip<T>(Option<LinkedList<Spine<T>>>) from Option<LinkedList<Spine<T>>>{
  @:from static public function fromSpine<T>(s:Spine<T>):Zip<T>{
    return lift(Some(Cons(s,LinkedList.unit())));
  }
  @:noUsing static public function lift<T>(self:Option<LinkedList<Spine<T>>>):Zip<T>{
    return new Zip(self);
  }
  @:noUsing static public function unit<T>():Zip<T>{
    return lift(Option.unit());
  }
  public function new(?self){
    if (self == null){
      self = None;
    }
    this = self;
  }
  public function indicant(ls:LinkedList<Section>){
    return ls.fold(
      function(next:Section,memo:Zip<T>):Zip<T>{
        return memo.down(next);
      },
      (this:Zip<T>)
    );
  }
  public function down(selector:Section):Zip<T>{
    return switch([this,selector]){
      case [Some(Cons(Collate(arr),xs)),Nominal(str)]:

        var val = arr.fold(
          function(next,memo:Option<Field<Thunk<Spine<T>>>>){
            return memo.fold(
              Option.pure,
              () -> next.key == str ? memo : Option.unit()
            );
          },
          Option.unit()
        );
        val.fold(
          (thk) ->
            this.map(
              function(ls){
                return ls.cons(thk.snd()());
              }
            ),
          () -> None 
        );
      //case [Some(Cons(Collect(arr),xs))]
      default : Option.unit();
    }
  }
  public function up(){
    return switch this {
      case Some(Cons(x,xs)) : Some(xs);
      default : None;
    }
  }
  public function is_root(){
    return switch this{
      case Some(Cons(x,Nil)) : true;
      default : false;
    }
  }
  public function is_defined(){
    return switch(this){
      case None:      false;
      case Some(Nil): false;
      default:        true;
    }
  }
  public function value():Option<Spine<T>>{
    return switch this {
      case Some(Cons(x,_)):  Some(x);
      default : None;
    };
  }
}