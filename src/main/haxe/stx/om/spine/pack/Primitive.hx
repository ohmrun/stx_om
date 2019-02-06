package stx.om.spine.pack;

import stx.om.sig.head.Data.PrimitiveKind;
import stx.om.spine.head.Data.Primitive in PrimitiveT;

abstract Primitive(PrimitiveT) from PrimitiveT to PrimitiveT{
    public function new(self){
        this = self;
    }
    @:from static public function fromBool(b):Primitive{
        return Boolean(b);
    }
    @:from static public function fromInt(i):Primitive{
        return Integer(i);
    }
    @:from static public function fromFloat(f):Primitive{
        return FloatingPoint(f);
    }
    @:from static public function fromString(i):Primitive{
        return Characters(i);
    }
    @:to public function toKind():PrimitiveKind{
        return switch(this){
            case FloatingPoint(_)       : TFloatingPoint;
            case Boolean(_)             : TBoolean;
            case Integer(_)             : TInteger;
            case Characters(_)          : TCharacters;
            case UntypedUnknown         : TUntypedUnknown;
        }
    }
    public function toString(){
        return switch(this){
            case FloatingPoint(v)       : '$v';
            case Boolean(v)             : '$v';
            case Integer(v)             : '$v';
            case Characters(v)          : '$v';
            case UntypedUnknown         : '_';
        }
    }
}