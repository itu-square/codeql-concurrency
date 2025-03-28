import java
import ConflictingAccess

from Field f, Class c
where
  isElementInThreadSafeAnnotatedClass(c, f) and
  not isSafelyPublished(f)
select f
