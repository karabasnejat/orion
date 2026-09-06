# Faz 1 doğrulama kaydı

## Gerçekleştirilen kontroller

- Godot: **4.5.1.stable.official.f62fdbde1**.
- Ortam: Linux, headless, 60 Hz fizik.
- Proje importu: geçti; script/parse hatası yok.
- Mekanik testleri: **60 kontrol, 0 hata** (yerel ve GitHub Actions).
- Araç: `GODOT_BIN=<godot yolu> tests/check.sh`.
- Ayrıntılı çalışma çıktısı: yerel `artifacts/tests.log`; CI aynı çıktıyı artifact olarak saklar.

Test kapsamı: saldırı pencereleri, aynı hedefe tekrar hasar, kombo hasarı, ağır iptali, zemin çarpışması, hareket hızı, çift zıplama, coyote sınırı, iniş tamponu, tek yönlü platform, kaçış mesafesi/bedeli/duvarı/hava limiti, yemin tetikleme ve bitişi, gerçek yakın dövüş çakışması, nöbetçi ön işareti, iyileşmenin kesilmesi/tamamlanması, mermi ve duvar, ekran dışı okçu, ölüm/yeniden başlama, gamepad kopma bildirimi ve zafer.

- GitHub Actions: [başarılı koşu](https://github.com/karabasnejat/orion/actions/runs/33999840854); mekanik testler ve Xvfb/OpenGL renderer kontrolü geçti.
- CI menü/arena PNG dosyaları indirilip görsel olarak incelendi; başlangıç menüsü 640×360 mantıksal alana sığıyor, düşman ön işareti ve oyuncu görünür.
- Temiz CI ortamında eksik ripgrep bağımlılığı saptandı; betik standart grep ile taşınabilir hale getirildi.

## Henüz doğrulanmayanlar

- Beş gerçek oyuncuyla his testi; kullanıcı memnuniyeti/ölüm anlaşılabilirliği metriği.
- Fiziksel gamepad; otomatik test yalnızca bağlantı kaybı olay işleyicisini sınar.
- Windows işletim sisteminde açılış ve oynanış.
- Referans GPU'da 1080p/60 FPS ve bellek ölçümü.
- Nihai animasyon, piksel sanat ve ses kalitesi (Faz 2).

Gerçek renderer görüntü testi CI'da menü yerleşimini ve ana sahnenin çizilebildiğini sınar; insan oynanış testi değildir. Sonuçları CI artifact ve PR üzerinden takip edilir.

## Manuel kontrol sırası

1. Başlat: başlangıç ekranı 720p ve 1080p'de sığıyor mu? Menü gamepad ile kullanılabiliyor mu?
2. Yemin açık/kapalı başlat: HUD seçimi ve kaçış sıklığı değişiyor mu?
3. Üç salonu gezin: kenardan geç zıplama, çift zıplama, aşağı geçiş, engel aşma.
4. Her iki düşmanı yalnızca hafif, ardından ağır saldırılarla yenin; kaçış pencerelerini deneyin.
5. Son anda kaçışı tetikleyin: güçlendirme gösterilsin, tek isabette tüketilsin, boşa vuruşta kalıp süre sonunda bitsin.
6. Hasar alırken iyileşin: kesilince yük tüketilmesin; başarılı kullanımda 40 can gelsin.
7. Esc/odak kaybı/gamepad çıkarma: dünya ve zamanlayıcılar dursun; geri dönüşte beklenmedik saldırı tetiklenmesin.
8. Ölün ve tekrar başlayın: tam can, iki yük, beş düşman; eski mermi ve efektler kalmasın.
9. Beş düşmanı yenip doğu mührüne girin: zafer ekranı, süre, yeni sefer.
10. Test günlüğünü açık ve kapalı deneyin; dosya yalnızca açıkken yazılsın.

## Beş kişilik oyun testi şablonu

Katılımcı kodu: T01–T05 (isim veya iletişim bilgisi gerekmez).

- Build / tarih:
- Cihaz / klavye veya gamepad:
- Aksiyon roguelite deneyimi: az / orta / yüksek
- İlk sefer süresi ve ulaşılan nokta:
- Dövüş hissi: 1–5
- Ölümün nedenini ve önlenme yolunu anlatabildi mi?
- Yemin avantajı ve bedelini anlatabildi mi?
- Yeniden denemeyi kendisi seçti mi?
- Kontrol/okunabilirlik sorunu ve yeniden üretim adımları:
- Yapılacak düzeltme / ilgili issue:

Oturum sonunda gözlemci ve oyuncu değerlendirmesi ayrı yazılır. Hiçbir satır test yapılmadan doldurulmaz. Faz 1 kapanışı bu kayıtları gerektirir.
