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

class PoisonedSink extends DataFlow::Node {
  FieldAccess fa;

  PoisonedSink() {
    exists(Assignment a | a.getLeftOperand() = fa |
      a.getRhs() = this.asExpr() and
      fa.getField().getType() instanceof RefType and
      fa.getField().getDeclaringType() instanceof ClassAnnotatedAsThreadSafe
    )
  }

  FieldAccess getFieldAccess() { result = fa }
}

private module PoisonedInternalStateFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asParameter().getType() instanceof RefType and
    isPublicEntryPoint(src.asParameter().getCallable())
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof PoisonedSink }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) { isSink(node) }
}

private module PoisonedInternalStateFlow = DataFlow::Global<PoisonedInternalStateFlowConfig>;

// int explorationLimit() { result = 100 }
// module PartialFlow = PoisonedInternalStateFlow::FlowExplorationFwd<explorationLimit/0>;
// from PartialFlow::PartialPathNode src, PartialFlow::PartialPathNode sink
// where PartialFlow::partialFlow(src, sink, _)
// select src, sink
import PoisonedInternalStateFlow::PathGraph

from PoisonedInternalStateFlow::PathNode source, PoisonedInternalStateFlow::PathNode sink
where PoisonedInternalStateFlow::flowPath(source, sink)
select sink.getNode().(PoisonedSink).getFieldAccess(), source, sink,
  "External state received via $@.", source.getNode(), "flows to internal state."
