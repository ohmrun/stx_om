package stx.om.spine.pack;

import stx.om.spine.head.data.SpineMap as SpineMapT;
import stx.om.spine.Package.Spine in SpineA;
import stx.om.spine.head.Data.Spine in SpineT;

@:forward abstract SpineMap(SpineMapT) from SpineMapT to SpineMapT{
    public function new(self:SpineMapT){
        this = self;
    }
    public function exists(key:String){
        return this.any(
            function(tp){
                return tp.fst() == key;
            }
        );
    }
    public function get(key:String){
        return this.find(
            function(tp){
                return tp.fst() == key;
            }
        );
    }
    public function unbox():SpineMapT{
        return this;
    }
    public function append(val:Field<Thunk<SpineA>>){
        return new SpineMap(this.add(val));
    }
    public function change(fn:SpineA->SpineA):SpineMap{
        var arr = this.map(
            (vr:Field<Thunk<SpineA>>) -> vr.map( 
                (f:Thunk<SpineA>) -> __.fn().thunk(f.then(fn)()) 
            )
        );
        return new SpineMap(cast arr);
    }
}