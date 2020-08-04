class ArrayUtil {
  static bool isEmpty(List array) {
    return (null == array || array.length <= 0);
  }

  static bool isNotEmpty(List array) {
    // not use array.isNotEmpty to 
    return (null != array && array.length > 0);
  }
}
