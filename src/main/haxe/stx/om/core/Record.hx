package stx.om.core;

typedef RecordDef<T> = Array<Field<Thunk<T>>>;

@:forward(iterator) abstract Record<T>(RecordDef<T>) from RecordDef<T>{
  public function new(?self:RecordDef<T>) this = self == null ? [] : self;

  public function size(){
    return this.length;
  }
  public function add(that:Field<Thunk<T>>):Record<T>{
    return this.concat([that]);
  }
  public function equals(that:Record<T>,with:Eq<T>):Bool{
    return if(this.length != that.size()){
      false;
    }else{
      var ok = true;
      for(v in this){
        var key   = v.key;
        var other = that.get(key);
        switch(other){
          case None       : false;
          case Some(v0)   : 
            if(!with.applyII(v.val(),v0()).ok()){
              ok = false;
              break;
            } 
        } 
      };
      ok;
    }
  }
  public function get(key:String):Option<Thunk<T>>{
    var out = None;
    for(v in this){
      if(v.key == key){
        out = Some(v);
        break;
      }
    }
    return switch(out){
      case Some(v)  : Some(v.val);
      default       : None;
    }
  }
  public function has(key){
    return get(key).map((_) -> true).def(()->false);
  }
  public function fold<U>(fn:Field<Thunk<T>>->U->U,i:U):U{
    var current = i;
    for(v in this){
      current = fn(v,current);
    }
    return current;
  }
  static public function reduct<T>(){
    return function(next:Field<Thunk<T>>,memo:Record<T>):Record<T>{
      return memo.add(next);
    }
  }
  public function map<U>(fn:T->U):Record<U>{
    return this.map(
      (fld) -> fld.map(
        (thk) -> {
          return () -> fn(thk());
        }
      )
    ).lfold(reduct(),new Record());
  }
  public function mapi<U>(fn:Int->T->U):Record<U>{
    return this.mapi(
      (i,fld) -> fld.map(
        (thk) -> {
          return () -> fn(i,thk());
        }
      )
    ).lfold(reduct(),new Record());
  }
  @:from static public function fromUnderlying<T>(arr:Array<Field<Thunk<T>>>){
    return new Record(arr);
  }
  public function prj():Array<Field<Thunk<T>>>{
    return this;
  }
}