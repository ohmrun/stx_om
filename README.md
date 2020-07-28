# stx_om

Jsonic type object model and signature with type holes.

```haxe
enum SpineSum<T>{
 Unknown;
 Primate(sc:Primitive);
 Collect(arr:Array<Thunk<Spine<T>>>);
 Collate(arr:Record<Spine<T>>);
 Predate(v:T);
}
```