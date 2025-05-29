/**
 * @name Escaping
 * @description In a thread-safe class, care should be taken to avoid exposing mutable state.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/escaping
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import ConflictingAccess

from Field f, ClassAnnotatedAsThreadSafe c
where
  f = c.getAField() and
  not f.isFinal() and // final fields do not change
  not f.isPrivate() and  
  // We believe that protected fields are also dangerous
  // Volatile fields and thread-safe classes cannot cause data races, but it is dubious to allow changes.
  // For now, we ignore these fields, but there are likely bugs to be caught here.
  not f.isVolatile()  and
  not isThreadSafeType(f.getType()) and
  not isThreadSafeType(f.getInitializer().getType()) 
select f, "The class $@ is marked as thread-safe, but this field is potentially escaping.", c,
  c.getName()
