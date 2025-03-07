/**
 * @name Escaping
 * @kind problem
 * @problem.severity warning
 * @id java/escaping
 */

import java

predicate isNotPrivateField(Field f) {
  not f.isPrivate()
}

predicate isNotPrivateClass(Class c) {
  not c.isPrivate()
}

predicate isNotFinal(Field f) {
  not f.isFinal()
}


predicate isElementInThreadSafeAnnotatedClass(Class c, Element e) {
  c.getAnAnnotation().toString() = "ThreadSafe"
  and c.contains(e)
}

from Field f, Class c
where isElementInThreadSafeAnnotatedClass(c, f) 
  and isNotPrivateField(f)
  and isNotFinal(f)
  and isNotPrivateClass(c)
select f, "Potentially escaping field"



