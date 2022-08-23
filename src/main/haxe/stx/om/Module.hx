package stx.om;

class Module extends Clazz{
  public function signature(){
    return new ModuleSignatureCtr();
  }
}
private class ModuleSignatureCtr extends Clazz{
  public function unknown<T>():Signature<T>{
    return new SignatureCtr().Unknown();
  }
  public function primate<T>(fn:CTR<PrimitiveTypeCtr,PrimitiveType>):Signature<T>{
    return new SignatureCtr().Primate(fn);
  }
  public function collect<T>(fn:CTR<SignatureCtr,Signature<T>>):Signature<T>{
    return new SignatureCtr().Collect(fn);
  }
  public function collate<T>(fn:CTR<SignatureCtr,Map<String,Signature<T>>>):Signature<T>{
    return new SignatureCtr().Collate(fn);
  }
  public function predate<T>(self:T):Signature<T>{
    return new SignatureCtr().Predate(self);
  }
}