package stx.om;

import tink.CoreApi;
using eu.ohmrun.Fletcher;
using stx.Test;
using eu.ohmrun.Pml;

class Test{
  static public function main(){
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
      (x) -> {
        trace(x);
      }
    ).load(__.pml().parse(string))
     .crunch();
  }
}