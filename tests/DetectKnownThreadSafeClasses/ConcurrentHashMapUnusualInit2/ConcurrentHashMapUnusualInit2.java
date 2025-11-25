import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

@ThreadSafe
public class ConcurrentHashMapUnusualInit2 {
  private final Map<String, String> x;

  public ConcurrentHashMapUnusualInit2() {
    x = new ConcurrentHashMap();
  }

  public Map<String, String> getMap() {
    return x;
  }

  public void compute(String name) {
    x.computeIfAbsent(name, k -> "value");
  }
}