@ThreadSafe
public class SafePublication {
    int x;
    int y = 0;
    int z = 3; // not OK
    int w;
    int u;

 public SafePublication(int a) {
    x = 0;
    w = 3; // not ok
    u = a; // not ok
  }
}