final regexSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
final regexUpperCase = RegExp(r'[A-Z]');
final regexLowerCase = RegExp(r'[a-z]');
final regexDigit = RegExp(r'[0-9]');

({bool isValid, String message}) checkPassword(String password) {
  password = password.trim();
  if (password.isEmpty) {
    return (isValid: false, message: 'Enter the password');
  }
  if (password.length < 8) {
    return (isValid: false, message: 'Password is too short');
  }
  if (!regexUpperCase.hasMatch(password)) {
    return (isValid: false, message: 'Use at least one uppercase letter');
  }
  if (!regexLowerCase.hasMatch(password)) {
    return (isValid: false, message: 'Use at least one lowercase letter');
  }
  if (!regexDigit.hasMatch(password)) {
    return (isValid: false, message: 'Use at least one digit');
  }
  if (!regexSpecialChar.hasMatch(password)) {
    return (isValid: false, message: 'Use at least one special character');
  }
  return (isValid: true, message: 'Password is valid');
}
