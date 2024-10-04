String formatPhoneNumber(String phoneNumber) {
  String firstTwo = phoneNumber.substring(0, 2);
  String lastFour = phoneNumber.substring(7, 10);
  String masked = '*' * 5;
  return '$firstTwo$masked$lastFour';
}
