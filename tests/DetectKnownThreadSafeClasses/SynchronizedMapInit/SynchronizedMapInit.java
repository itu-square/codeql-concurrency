import java.util.Map;
import java.util.HashMap;
import java.util.Collections;

@ThreadSafe
public class SynchronizedMapInit {
  private final Map<Integer, Integer> map;

  public SynchronizedMapInit() {
    map = Collections.synchronizedMap(new HashMap<Integer, Integer>());
  }

  public Integer checkContaints(Integer i) {
    return map.get(i);
  }

  public void set(Integer i, Integer v) {
    map.put(i,v);
  }
}