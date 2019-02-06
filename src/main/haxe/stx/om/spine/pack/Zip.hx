package stx.om.spine.pack;

abstract Zip(Option<List<Spine>>) from Option<List<Spine>>{
  @:from static public function fromSpine(s:Spine):Zip{
    return Some(Cons(s,List.unit()));
  }
  public function new(?self){
    if (self == null){
      self = None;
    }
    this = self;
  }
  public function indicant(ls:List<Section>){
    return ls.fold(
      function(next:Section,memo:Zip):Zip{
        return memo.down(next);
      },
      (this:Zip)
    );
  }
  public function down(selector:Section):Zip{
    return switch([this,selector]){
      case [Some(Cons(SRecord(arr),xs)),Choice(str)]:
        var val = arr.fold(
          function(next,memo:Option<Thunk<Spine>>){
            return memo.fold(Some,
              () -> next.key == str ? Some(memo) : None
            );
          },
          None
        );
        if(val == null){
          None;
        }else{
          this.map(
            function(ls){
              return ls.cons(val.snd().get()());
            }
          );
        }
      default : None;
    }
  }
  public function up(){
    return switch this {
      case Some(Cons(x,xs)) : Some(xs);
      default : None;
    }
  }
  public function isRoot(){
    return switch this{
      case Some(Cons(x,Nil)) : true;
      default : false;
    }
  }
  public function isDefined(){
    return switch(this){
      case None:      false;
      case Some(Nil): false;
      default:        true;
    }
  }
  public function value():Option<Spine>{
    return switch this {
      case Some(Cons(x,_)):  Some(x);
      default : None;
    };
  }
}