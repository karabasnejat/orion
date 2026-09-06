# Geliştirme kuralları

- PRD tasarım kaynağıdır; uygulamanın kapsadığı alt küme README ve ROADMAP'te açık tutulur.
- Her iş ilgili issue'ya bağlanır; kapsam değişikliği gerekçesiyle dokümante edilir.
- Godot 4.5.1 ve 60 Hz fizik kullanılır. Sürüm değişikliği ayrı iş ve doğrulama gerektirir.
- Mekanik zamanlar simülasyon delta'sından türetilir; çizim kare sayısından veya UI zamanından hesaplanmaz.
- Kalıcı içerik kimlikleri veri dosyalarında tutulur. Ödül ve hasar mantığı çizim koduna taşınmaz.
- Kod açıklamaları İngilizce; ürün metinleri bu prototipte Türkçe. Tam TR/EN anahtarları Faz 3'tedir.
- `.godot/`, kişisel günlük, binary motor ve yerel `artifacts/` git'e eklenmez. `.gd.uid` dosyaları sürümlenir.
- Değişen mekanik için sınır durumunu doğrulayan test eklenir. Biçim değişikliği için gereksiz test yazılmaz.
- PR açıklaması: problem, davranış değişikliği, test kanıtı, henüz doğrulanmayan noktalar.
- İnsan testi yapılmadan kullanıcı başarı metrikleri tamamlandı sayılmaz.
- Yeni içerik sayısını büyütmeden ilgili faz çıkış kapısı gözden geçirilir.
