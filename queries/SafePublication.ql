/**
 * @name Safe publication
 * @kind problem
 * @problem.severity error
 * @id java/safe-publication
 */

import java
import ConflictingAccess

predicate isElementInThreadSafeAnnotatedClass(Class c, Field f) {
  c.getAnAnnotation().toString() = "ThreadSafe" and
  f = c.getAField()
}



predicate isSafelyPublished(Field f) {
    f.isFinal() or  // what about non-primitive types
    f.isStatic() or 
    f.isVolatile() or
    isThreadSafeType(f.getType()) or 
    isDefaultValue(f)
}



// What about other datatypes
// https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html -- See default values
// And what about arrays?

/*
  *
  * int/long x;
  * * int/long x = 3; not ok

  public c(a) {
    x = 0;
    x = 3; not ok
    x = a; not ok
  }

*/

predicate isDefaultValue(Field f) {
  f.getType().hasName(["int", "long"]) and f.getAnAssignedValue().toString() = "0"
  or
  f.getType().hasName("boolean") and f.getAnAssignedValue().toString() = "false"
  or
  f.getAnAssignedValue().toString() = "null"
}

from Field f, Class c
where
  isElementInThreadSafeAnnotatedClass(c, f) and
  not isSafelyPublished(f)
select f, "This field is not safely published"
/*
 * *** TODO: Detected false positives to fix ***
 *
 * 1. If value is initialized to nothing (i.e., default), then we must check that it is not updated in the constructor.
 *
 */

