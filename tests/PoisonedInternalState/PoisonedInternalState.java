@ThreadSafe
public class PoisonedInternalState {
    int x;
    Object o;

  public PoisonedInternalState() {
    o = new Object();
    x = 0;
  }

  public PoisonedInternalState(Object po, int x) {
    o = po; // $Alert
    this.x = x;
  }

  public int revealPrimitive() {
    return x;
  }

  public void setReference(Object o) {
    this.o = o; // $Alert
  }

  public void setViaMethodCall(Object o) {
    setInternalReference(o);
  }

  private void setInternalReference(Object o) {
    this.o = o; // $Alert
  }
}