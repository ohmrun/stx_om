package stx.om.spine.term;

typedef SpineHaxeEnumDef<T> = {
  final name      : String;
  final construct : String;
  final params    : Record<Spine<T>>;
}
//typedef SpineHaxe = Spine<SpineHaxeEnumDef>; 