package stx.om.spine;

#if test
  import stx.om.spine.test.*;
#end
typedef Route       = stx.om.spine.pack.Route;
typedef Section     = stx.om.spine.pack.Section;
typedef Spine<T>    = stx.om.spine.pack.Spine<T>;
typedef Zip<T>      = stx.om.spine.pack.Zip<T>;

class Package {
  #if test
    static public function tests():Array<utest.Test>{
      return [new SpineTest()];
    }
  #end
}