String formatPhoneNumber(String phoneNumber) {
  String firstTwo = phoneNumber.substring(0, 2);
  String lastthree = phoneNumber.substring(7, 10);
  String masked = '*' * 5;

  return '$firstTwo$masked$lastthree';
}
