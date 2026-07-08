import 'dart:math' as math;

abstract final class SkuUtils {
  static final RegExp skuRegex = RegExp(r'^[A-Z0-9]{3,4}-[A-Z0-9]{4}-[A-Z0-9]{4}$');

  /// Centrally validates a Global SKU for non-emptiness, spacing, format, and uniqueness.
  static String? validateGlobalSku(
    String? sku, {
    List<String> existingSkus = const [],
    String? currentSku,
  }) {
    if (sku == null || sku.isEmpty) {
      return 'Global SKU is required';
    }
    if (sku.contains(' ')) {
      return 'No spaces allowed';
    }
    final uppercaseSku = sku.trim().toUpperCase();
    if (!skuRegex.hasMatch(uppercaseSku)) {
      return 'Invalid format. Must be XXX-XXXX-XXXX.';
    }
    
    // Check uniqueness across provided existing SKUs
    if (existingSkus.isNotEmpty) {
      final isUnique = !existingSkus.any(
        (existing) =>
            existing.trim().toUpperCase() == uppercaseSku &&
            existing.trim().toUpperCase() != currentSku?.trim().toUpperCase(),
      );
      if (!isUnique) {
        return 'SKU already exists.';
      }
    }
    return null;
  }

  /// Generates a compliant SKU of format "XXX-XXXX-XXXX" (e.g. "BTX-0001-UPRF")
  /// that is guaranteed to be unique against [existingSkus].
  static String generateSku({List<String> existingSkus = const []}) {
    final rand = math.Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';
    String generated;
    do {
      final prefix = String.fromCharCodes(
        Iterable.generate(
          3,
          (_) => letters.codeUnitAt(rand.nextInt(letters.length)),
        ),
      );
      final seg1 = String.fromCharCodes(
        Iterable.generate(
          4,
          (_) => digits.codeUnitAt(rand.nextInt(digits.length)),
        ),
      );
      final seg2 = String.fromCharCodes(
        Iterable.generate(
          4,
          (_) => letters.codeUnitAt(rand.nextInt(letters.length)),
        ),
      );
      generated = '$prefix-$seg1-$seg2';
    } while (existingSkus.any((sku) => sku.trim().toUpperCase() == generated));
    return generated;
  }
}
