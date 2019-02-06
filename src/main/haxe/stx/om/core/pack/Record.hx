package stx.om.core.pack;


import stx.assert.pack.Eq;
import stx.om.core.head.data.Record in RecordT;

abstract Record<T>(RecordT<T>) from RecordT<T>{
  public function new(?self) this = self == null ? [] : self;

  public function size(){
    return this.length;
  }
  public function add(that:Field<Thunk<T>>):Record<T>{
    return this.concat([that]);
  }
  public function equals(that:Record<T>,with:Eq<T>){
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
            if(!with(v.val(),v0())){
              ok = false;
              break;
            } 
        } 
      }
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
    return get(key).isDefined();
  }
  public function fold<U>(fn:Field<Thunk<T>>->U->U,i:U):U{
    return Lambda.fold(this,fn,i);
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
          return () -> fn(thk())
        }
      )
    ).fold(reduct(),new Record());
  }
}