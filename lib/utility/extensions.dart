extension StringExtension on String {
  bool isValidUserName() {
    var reg = RegExp(r'^(?=.{6,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$')
        .hasMatch(this);
    return reg;
  }

  String isPasswordValid() {
    if (this.length < 8) return 'Password should not be less than 8 characters';
    if (!this.contains(RegExp(r"[a-z]")))
      return 'Password should contain atleast 1 lowercase letter';
    if (!this.contains(RegExp(r"[A-Z]")))
      return 'Password should contain atleast 1 uppercase letter';
    if (!this.contains(RegExp(r"[0-9]")))
      return 'Password should contain atleast 1 digit';
    if (!this.contains(RegExp(r'[!@#$%^&£*(),.?":{}|<>]')))
      return 'Password should contain atleast 1 special character';
    return null;
  }
}
