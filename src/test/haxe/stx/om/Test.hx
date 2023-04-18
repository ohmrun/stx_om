package stx.om;

using stx.Ds;
using stx.Log;
using stx.Nano;
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
    __.test().run([
      new PmlParseTest()
    ],[]);
  }
}
class PmlParseTest extends TestCase{
  public function test(){
    final string  = __.resource("test.pml").string();
    __.ctx(
      Noise,
      (x:ParseResult<Token,PExpr<Atom>>) -> {
          for (e in x.error){
            trace("_____________");
            trace(e);
            trace("!!!!!!!!!!!!!");
          }
          for(val in x.toRes().option().flat_map(x -> x)){
            //trace(__.show(val));
            handle(val);
          }
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
        case PGroup(Cons(PValue(lhs),Cons(rhs,Nil))) : 
          trace(rhs);
        default : 
          trace(expr);
      }
    }
    function object(expr){
      trace(expr);
      switch(expr){
        case PGroup(list)    : 
          for(tup2 in list){
            tuple2(tup2);
          }
        default             : throw "object";
      }
    }
    switch(expr){
      case PGroup(list) : 
        for(obj in list){
          object(obj);
        }
      default : throw "objects";
    }
  }
}