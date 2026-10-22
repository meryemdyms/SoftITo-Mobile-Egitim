
# Ritmo — Agent Çalışma Kuralları

1. Her görevden önce `project.md` dosyasını oku. Ardından göreve uygun `.agents/skills/` altındaki SKILL.md dosyalarını incele.

2. `project.md` ürün kararları için ana kaynaktır. Kullanıcı istemedikçe özellikleri, iş kurallarını veya tasarım sistemini değiştirme.

3. Flutter projesinde feature-first mimari kullan. UI, state yönetimi ve veri erişimini birbirinden ayır.

4. Kod yazmadan önce etkilenecek feature ve dosyaları belirle. Gereksiz dosya oluşturma veya mevcut yapıyı değiştirme.

5. Tüm ekranlarda `ui-design` kurallarına uy. Sabit renk, tekrar eden stil ve gereksiz karmaşık widget yapıları oluşturma.

6. Alışkanlık, streak, yapboz ve analiz hesaplamalarını UI içerisinde gerçekleştirme. İş kurallarını ilgili katmanda yönet.

7. Gizli yapboz sisteminin temel kurallarını koru:
   - Her başarılı planlı gün bir parça kazandırır.
   - Parçalar önceden belirlenmiş rastgele sırayla açılır.
   - Aynı parça tekrar kazanılmaz.
   - Eksik günler parça kazandırmaz.
   - Eksik parçalar süreç sonunda açılmaz.

8. Mevcut işlevleri bozmadan geliştir. Yeni bağımlılık eklemeden önce gerçekten gerekli olup olmadığını değerlendir.

9. Oluşturulan veya değiştirilen feature için ilgili testleri yaz ya da güncelle. `flutter analyze` ve uygun testleri çalıştır.

10. Görev sonunda değiştirilen dosyaları, yapılan işlemleri, test sonuçlarını ve varsa eksik kalan konuları kısaca bildir.
