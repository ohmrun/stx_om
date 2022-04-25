package stx.om.spine;

enum LenseSum<T>{
  LsId;
  LsConstant(value:Spine<T>,_default:Spine<T>);
  LsSequence(l:Lense<T>,r:Lense<T>);
  
  LsRename(source:String,target:String);
  LsHoist(name:String);
  LsPivot(name:String);

  LsXFork(from:RedBlackSet<String>,into:RedBlackSet<String>,lhs:Lense<T>,rhs:Lense<T>);
  LsMap(lense:Lense<T>);
}
@:using(stx.om.spine.Lense.LenseLift)
abstract Lense<T>(LenseSum<T>) from LenseSum<T> to LenseSum<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:LenseSum<T>):Lense<T> return new Lense(self);

  public function prj():LenseSum<T> return this;
  private var self(get,never):Lense<T>;
  private function get_self():Lense<T> return lift(this);
}
class LenseLift{
  static public function put<T>(self:Lense<T>,data:Spine<T>):Res<Spine<T>,OMFailure>{
    return switch(self){
      case LsId                                   : __.accept(data);
      case LsConstant(value,_default)             : __.accept(value);
      case LsSequence(l,r)                        : put(l,data).flat_map(
        x -> put(r,x)
      );
      case LsRename(source,target)                : switch(data){
        case Collate(rec) : rec.get(source).fold(
          _ -> __.accept(
            Collate(rec.fold(
              (next:Field<Thunk<Spine<T>>>,memo:Record<Spine<T>>) -> if(next.key == source){
                memo.add(Field.make(target,next.val));
              }else{
                memo.add(Field.make(next.key,next.val));
              },
              Record.unit()
            ))
          ),
          () -> __.reject(__.fault().of(E_OM_KeyNotFound(source)))
        );
        default           : __.reject(__.fault().of(E_OM_KeyNotFound(source)));
      }
      case LsHoist(name)                          : switch(data){
        case Collate(rec) : rec.get(name).fold(
          ok -> __.accept(ok()),
          () -> __.accept(Unknown)
        );
        default           : __.reject(__.fault().of(E_OM_KeyNotFound(name)));
      }
      case LsPivot(name)                          : switch(data){
        case Collate(rec) : rec.get(name).fold(
          (ok) -> {
            return switch(ok()){
              case Collate(recI) : 
                //TODO referential issue?
                final rest = rec.prj().filter(
                  (x) -> x.val()!=ok() 
                );
                final next = recI.prj().head();
                return next.fold(
                  ok -> __.accept(Record.unit().add(Field.make(ok.key,() -> Collate(rest)))),
                  () -> __.reject(__.fault().of(E_OM_UnexpectedEmpty))
                );
              default : __.reject(__.fault().of(E_OM_UnexpectedEmpty));
            }
          },
          () -> __.reject(__.fault().of(E_OM_KeyNotFound(name)))
        ).map(Collate);
        default           : __.reject(__.fault().of(E_OM_KeyNotFound(name)));
      }
      case LsXFork(from,into,lhs,rhs)   : 
        switch(data){
          case Collate(rec) : 
            final sets = rec.prj().partition(
              x -> from.has(x.key)
            );
            final lval = Collate(Record.lift(sets.a.imm()));
            final rval = Collate(Record.lift(sets.b.imm()));
            final l : Res<Spine<T>,OMFailure> = put(lhs,lval);
            final r : Res<Spine<T>,OMFailure> = put(rhs,rval);

            l.zip(r).flat_map(
              __.decouple(
                (lres,rres) -> switch([lres,rres]){
                  case [Collate(ls),Collate(rs)] : 
                    final set_fails = ls.fold(
                      (next:Field<Thunk<Spine<T>>>,memo:Report<OMFailure>) -> memo.concat(into.has(next.key).if_else(
                        () -> Report.unit(),
                        () -> __.report(_ -> _.of(E_OM_UnexpectedKey(next.key)))
                      )),
                      Report.unit()
                    ).resolve(
                      () -> ls
                    );
                    final unset_fails = rs.fold(
                      (next:Field<Thunk<Spine<T>>>,memo:Report<OMFailure>) -> memo.concat((!into.has(next.key)).if_else(
                        () -> Report.unit(),
                        () -> __.report(_ -> _.of(E_OM_UnexpectedKey(next.key)))
                      )),
                      Report.unit()
                    ).resolve(
                      () -> rs
                    );
                    set_fails.zip(unset_fails).map(
                      __.decouple(
                        (a:Record<Spine<T>>,b:Record<Spine<T>>) -> Collate(a.concat(b))
                      )
                    );
                  default : __.reject(__.fault().of(E_OM_UMatchedValueType()));
                }
              ) 
            );
          default : __.reject(__.fault().of(E_OM_NotFound));
        }
      case LsMap(lense)                           : 
        switch(data){
          case Collate(x) : x.fold(
            (next:Field<Thunk<Spine<T>>>,memo:Res<Record<Spine<T>>,OMFailure>) -> memo.flat_map(
              record -> put(lense,next.val()).map(
                item -> record.add(Field.make(next.key,() -> item))
              )
            ),
            __.accept(Record.unit())
          ).map(Collate);
          case Collect(x) : x.lfold(
            (next:Thunk<Spine<T>>,memo:Res<Cluster<Thunk<Spine<T>>>,OMFailure>) -> memo.flat_map(
              (cluster) -> put(lense,next()).map(
                y -> cluster.snoc(() -> y)
              )
            ),
            __.accept(Cluster.unit())
          ).map(Collect);
          default : __.reject(__.fault().of(E_OM_UMatchedValueType()));
        }
    }
  }
}