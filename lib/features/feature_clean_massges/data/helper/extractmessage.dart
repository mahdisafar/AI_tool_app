Map<String, String>? extractMessageDetails(String response) {
  // این نسخه نسبت به فضاهای خالی و خطوط اضافه منعطف‌تر است
  final RegExp regex = RegExp(
    r'STYLE:\s*(.*)\s*TITLE:\s*(.*)\s*BODY:\s*([\s\S]*)',
    caseSensitive: false,
  );

  final match = regex.firstMatch(response.trim());

  if (match != null && match.groupCount >= 3) {
    return {
      'style': match.group(1)?.trim() ?? '',
      'title': match.group(2)?.trim() ?? '',
      'body': match.group(3)?.trim() ?? '',
    };
  }
  return null;
}
