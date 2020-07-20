package stx.om.spine;

#if test
  import stx.om.spine.test.*;
#end
typedef Route       = stx.om.spine.pack.Route;
typedef Section     = stx.om.spine.pack.Section;
typedef Spine       = stx.om.spine.pack.Spine;
typedef Zip         = stx.om.spine.pack.Zip;

class Package {
  #if test
    static public function tests():Array<utest.Test>{
      return [new SpineTest()];
    }
  #end
}