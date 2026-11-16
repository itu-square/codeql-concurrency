@ThreadSafe
public class LeakingInternalState {
    int x;
    Object o;

 public LeakingInternalState() {
    o = new Object();
    x = 0;
  }

  public int revealPrimitive() {
    return x;
  }

  public Object revealReference() {
    return o; // $Alert
  }

  public Object revealAlias() {
    Object alias = o;
    return alias; // $Alert
  }

  public Object revealViaMethodCall() {
    return getReference(); // $Alert
  }

  private Object getReference() {
    return o;
  }
}