/**
 * @name Safe publication
 * @kind problem
 * @problem.severity error
 * @id java/safe-publication
 */

import java
import ConflictingAccess

predicate isElementInThreadSafeAnnotatedClass(Class c, Field f) {
  c = annotatedAsThreadSafe() and
  f = c.getAField()
}

predicate isSafelyPublished(Field f) {
  f.isFinal() or
  f.isStatic() or
  f.isVolatile() or
  isThreadSafeType(f.getType()) or
  isThreadSafeType(f.getInitializer().getType()) or
  isAssignedDefaultValue(f)
}

// What about other datatypes
// https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html -- See default values
// And what about arrays?
/*
 * int/long x;
 * * int/long x = 3; not ok
 *
 *  public c(a) {
 *    x = 0;
 *    x = 3; not ok
 *    x = a; not ok
 *  }
 */

/*
 * Holds if all constructor or initial assignments (if any) are to the default value.
 * That is, assignments by the declaration:
 *   int x = 0; OK
 *   int x = 3; not OK
 * or inside a constructor:
 *   public c(a) {
 *     x = 0; OK
 *     x = 3; not OK
 *     x = a; not OK
 *   }
 */

Expr shouldBeDefaultValue(Field f) {
  result = f.getAnAssignedValue() and
  (
    result = f.getInitializer()
    or
    result.getEnclosingCallable() = f.getDeclaringType().getAConstructor()
  )
}

Expr getDeafultValue(Field f) {
  f.getType().hasName("int") and result.(IntegerLiteral).getIntValue() = 0
  or
  f.getType().hasName("double") and result.(DoubleLiteral).getDoubleValue() = 0.0
  or
  f.getType().hasName("long") and result.(LongLiteral).getLiteral() = ["0", "0L"]
  or
  f.getType().hasName("boolean") and result.(BooleanLiteral).getBooleanValue() = false
  or
  not f.getType().getName() in ["int", "long", "double", "boolean"] and
  result instanceof NullLiteral
}

predicate isAssignedDefaultValue(Field f) {
  forall(Expr v | v = shouldBeDefaultValue(f) | v = getDeafultValue(f))
}

from Field f, Class c
where
  isElementInThreadSafeAnnotatedClass(c, f) and
  not isSafelyPublished(f)
select f, "This field is not safely published"
/*
 * *** TODO: Detected false positives to fix ***
 *
 * 1. Look at the variable timeOfLastCommitMillis in this class: https://github.com/debezium/debezium/blob/9b4fc32d038755347f1d48cf2801308096b7a1f2/debezium-embedded/src/main/java/io/debezium/embedded/EmbeddedEngine.java#L325C18-L325C40
 * 
 * The variable is initiliazed as long timeOfLastCommitMillis = 0 and not changed in the constructor. However, we report an error.
 */

