/**
 * @name Escaping
 * @kind problem
 * @problem.severity warning
 * @id java/escaping
 */

import java
import ConflictingAccess

predicate isNotPrivateField(Field f) { not f.isPrivate() }

predicate isNotFinal(Field f) { not f.isFinal() }

predicate isNotVolatile(Field f) {not f.isVolatile()}

predicate isFieldinThreadSafeAnnotatedClass(ClassAnnotatedAsThreadSafe c, Field f) {
  c.getAnAnnotation().toString() = "ThreadSafe" and
  f = c.getAField()
}

from Field f, ClassAnnotatedAsThreadSafe c
where
  isFieldinThreadSafeAnnotatedClass(c, f) and
  isNotPrivateField(f) and
  isNotFinal(f) and // final fields do not change
  // not f.isProtected() and // I believe that protected fields are also dangerous
  // isNotVolatile(f) and // volatile fields cannot cause data races, but it is weird to allow changes. What should we do?
  not c.isPrivate() // redundant?
select f, "Potentially escaping field"
