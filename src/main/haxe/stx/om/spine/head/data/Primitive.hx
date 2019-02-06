package stx.om.spine.head.data;

enum Primitive{
  Boolean(b:Bool);//ABool
  Integer(i:Int);//AInt
  FloatingPoint(f:Float);//AFloat
  Characters(s:String);//AString
  UntypedUnknown;//ANull;
}