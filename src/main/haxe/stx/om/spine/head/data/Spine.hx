package stx.om.spine.head.data;

import stx.om.spine.pack.SpineMap;
import stx.om.spine.pack.Spine in SpineA;
import stx.om.spine.pack.Primitive in PrimitiveA;
//https://github.com/purescript/purescript-generics/blob/master/docs/Data/Generic.md
enum Spine{
  SRecord(arr:SpineMap);
  SScalar(sc:PrimitiveA);
  SArray(arr:ReadOnlyArray<Thunk<SpineA>>);
  //SEnum(tag:String,val:Thunk<SpineA>);
  SEmpty;
}
/*
enum Spine<T>{
  
}
*/
/*
            switch(s){
                case SRecord(rec):
                case SScalar(sc):
                case SArray(arr):
                case SEmpty:
            }
*/
