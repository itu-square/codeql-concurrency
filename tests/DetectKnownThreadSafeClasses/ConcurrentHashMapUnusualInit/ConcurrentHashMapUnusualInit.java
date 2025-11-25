import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;

@ThreadSafe
public class ConcurrentHashMapUnusualInit {
  private final Set<Integer> set;

  public ConcurrentHashMapUnusualInit() {
    set = ConcurrentHashMap.newKeySet();
  }

  public boolean checkContaints(String toCheck) {
    return set.contains(toCheck);
  }

  public void clearSet() {
    set.clear();
  }
}