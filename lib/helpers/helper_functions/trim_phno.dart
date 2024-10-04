String trimPhone(String phone) {
  int len = phone.trim().length;
  int phLen = 10;
  if (len > 10) {
    int start = len - phLen;
    phone = phone.trim().substring(start, len);
  }
  return phone;
}
