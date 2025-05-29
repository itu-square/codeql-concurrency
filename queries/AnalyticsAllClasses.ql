/**
 * @name Repo info Analytics
 * @id java/codeql-concurrency/analytics/all_classes
 */

import java
import ConflictingAccess

select count(Class c | c.fromSource() | c) as num_classes, 
       sum(Class c | c.fromSource() | c.getMetrics().getNumberOfExplicitFields()) as num_fields,
       sum(Class c | c.fromSource() | c.getMetrics().getNumberOfMethods()) as num_methods, 
       sum(Class c | c.fromSource() | c.getMetrics().getNumberOfLinesOfCode()) as loc