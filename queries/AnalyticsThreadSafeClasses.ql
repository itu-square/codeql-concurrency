/**
 * @name Repo info Analytics
 * @id java/codeql-concurrency/analytics/thread_safe_classes
 */

import java
import ConflictingAccess

select count(ClassAnnotatedAsThreadSafe c | c.fromSource() | c) as num_classes, 
       sum(ClassAnnotatedAsThreadSafe c | c.fromSource() | c.getMetrics().getNumberOfExplicitFields()) as num_fields,
       sum(ClassAnnotatedAsThreadSafe c | c.fromSource() | c.getMetrics().getNumberOfMethods()) as num_methods, 
       sum(ClassAnnotatedAsThreadSafe c | c.fromSource() | c.getMetrics().getNumberOfLinesOfCode()) as loc