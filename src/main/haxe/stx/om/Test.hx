package stx.om;

using stx.Show;
using stx.Parse;
import tink.CoreApi;
using eu.ohmrun.Fletcher;
using stx.Test;
using eu.ohmrun.Pml;

class Test{
  static public function main(){
    final log = __.log().global;
          //log.includes.push("eu/ohmrun/pml");
          //log.includes.push("stx/parse");
          //log.level = TRACE;
    __.test([
      new PmlParseTest()
    ],[]);
  }
}
class PmlParseTest extends TestCase{
  public function test(){
    final string  = __.resource("test.pml").string();
    __.ctx(
      Noise,
      (x:Res<ParseResult<Token,PExpr<Atom>>,Noise>) -> {
        x.point(
          y -> {
            for (e in y.error){
              trace("_____________");
              trace(e);
              trace("!!!!!!!!!!!!!");
            }
            for(val in y.toRes().option().flat_map(x -> x)){
              //trace(__.show(val));
              handle(val);
            }
            
            return __.report();
          }
        ).raise();
      }
    ).load(__.pml().parse(string))
     .crunch();
  }
  function handle(expr:PExpr<Atom>){
    function value(expr){
      switch(expr){
        default : 
      }
    }
    function tuple2(expr){
      switch(expr){
        case Group(Cons(Value(lhs),Cons(rhs,Nil))) : 
          trace(rhs);
        default : 
          trace(expr);
      }
    }
    function object(expr){
      trace(expr);
      switch(expr){
        case Group(list)    : 
          for(tup2 in list){
            tuple2(tup2);
          }
        default             : throw "object";
      }
    }
    switch(expr){
      case Group(list) : 
        for(obj in list){
          object(obj);
        }
      default : throw "objects";
    }
  }
}