/**
 * @name Poisoned internal state
 * @description External values being assigned to internal state allows for external modification of internal state.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/poisoned-internal-state
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

private module PoisonedInternalStateFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asParameter().getType() instanceof RefType and
    isPublicEntryPoint(src.asParameter().getCallable())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FieldAccess fa | fa = sink.asExpr() |
      fa.getField().getType() instanceof RefType and
      fa.getField().getDeclaringType() instanceof ClassAnnotatedAsThreadSafe and
      fa.isVarWrite()
    )
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) { isSink(node) }
}

private module PoisonedInternalStateFlow = DataFlow::Global<PoisonedInternalStateFlowConfig>;

import PoisonedInternalStateFlow::PathGraph

from PoisonedInternalStateFlow::PathNode source, PoisonedInternalStateFlow::PathNode sink
where PoisonedInternalStateFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "External state received via $@.", source.getNode(),
  "flows to internal state."
