import 'package:flutter/material.dart';

/// Finansal işlemleri ) temsil eden model sınıfı.
class TransactionItem {
  final String id;
  /// İşlem başlığı
  final String title;
  /// İşlemin kategorisi veya kısa açıklaması
  final String category;
  /// İşlemin yapıldığı zaman/tarih bilgisi metin formatında 
  final String date;
  final double amount;

  /// İşlemin türünü belirten mantıksal bayrak:
  /// - `true`: Gider / Harcama
  /// - `false`: Gelir / Kazanç 
  final bool isExpense;

  final IconData icon;

  /// TransactionItem kurucu metodu (Constructor).
  const TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.icon,
  });
}