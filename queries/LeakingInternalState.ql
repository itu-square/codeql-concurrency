/**
 * @name Leaking internal state
 * @description Returning internal state directly from a method
 *              allows for leaking internal state.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/leaking-internal-state
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import ConflictingAccess
private import semmle.code.java.dataflow.DataFlow

private predicate isPublicEntryPoint(Callable c) {
  c.isPublic() and
  not c.getAnAnnotation().getType().getName() = "VisibleForTesting"
}

private module LeakingInternalStateFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(FieldAccess fa | fa = src.asExpr().(FieldAccess) |
      fa.getField().getType() instanceof RefType and
      fa.getField().getDeclaringType() instanceof ClassAnnotatedAsThreadSafe and
      // public fields are directly a problem and would be reported by another query
      not fa.getField().isPublic() and
      fa.isVarRead()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().getType() instanceof RefType and
    exists(ReturnStmt s | isPublicEntryPoint(s.getEnclosingCallable()) |
      sink.asExpr() = s.getExpr()
    )
  }
}

private module LeakingInternalStateFlow = DataFlow::Global<LeakingInternalStateFlowConfig>;

import LeakingInternalStateFlow::PathGraph

from LeakingInternalStateFlow::PathNode source, LeakingInternalStateFlow::PathNode sink
where LeakingInternalStateFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Internal state defined at $@.", source.getNode(),
  "flows to return value."
