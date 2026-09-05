# Faz planı ve güncel durum

Temel kaynak: [PRD](PRD.md). Tarih: 2026-09-05. İnsan oyun testi ve satış sürümü bu PR kapsamında tamamlanmış sayılmaz.

| Faz | GitHub | Durum | Çıkış kapısı |
|---|---|---|---|
| 0 — Ön üretim | [#1](https://github.com/karabasnejat/orion/issues/1) | Uygulandı, PR incelemesinde | Proje importu, belgeler ve test komutu |
| 1 — Dövüş prototipi | [#2](https://github.com/karabasnejat/orion/issues/2) | Kod hazır; doğrulama ve oyun testi sürüyor | Hareket/dövüş testleri + 5 kişilik his testi |
| 2 — Vertical slice | [#3](https://github.com/karabasnejat/orion/issues/3) | Bekliyor | 8 oda, ilk boss, hedef sanat/ses, 10 yeni oyuncu |
| 3 — MVP | [#4](https://github.com/karabasnejat/orion/issues/4) | Bekliyor | 22 oda, kurallı üretim, ekonomi, kayıt, 3×3 kurulum |
| 4 — MVP doğrulama | [#5](https://github.com/karabasnejat/orion/issues/5) | Bekliyor | Denge, 20 saat QA, erişilebilirlik, Windows paket |
| 5 — 1.0 | [#6](https://github.com/karabasnejat/orion/issues/6) | MVP sonucuna bağlı | Yeni bölgeler ve final; yeniden tahmin edilmiş bütçe |

## Faz 1 görevleri

| Görev | Uygulama | Kanıt / kalan iş |
|---|---|---|
| [#7 Hareket](https://github.com/karabasnejat/orion/issues/7) | Tamam | Gerçek fizik üzerinden zıplama, coyote, tampon, platform testleri |
| [#8 Kaçış ve Avcı Yemini](https://github.com/karabasnejat/orion/issues/8) | Tamam | Mesafe, pencere, duvar, hava limiti ve tek tetik testleri |
| [#9 Kılıç](https://github.com/karabasnejat/orion/issues/9) | Tamam | Hasar defteri, kombo ve ağır iptal penceresi testleri |
| [#10 Düşmanlar](https://github.com/karabasnejat/orion/issues/10) | Tamam | Nöbetçi ön işareti, okçu mermisi ve duvar testi |
| [#11 Arena döngüsü](https://github.com/karabasnejat/orion/issues/11) | Tamam | İyileşme, ölüm, tekrar, kopma ve zafer testleri |
| [#12 Doğrulama ve his testi](https://github.com/karabasnejat/orion/issues/12) | Devam ediyor | Otomatik mekanik testleri hazır; 5 gerçek oyuncu bekleniyor |

“Uygulandı” geliştirme dalındaki kodu ifade eder. Issue'lar PR birleştirilene kadar açık tutulur. Faz 1 ve #12, insan testi tamamlanmadan kapatılmaz.

## Sıradaki adımlar

1. CI sonucunu ve gerçek renderer menü/arena görüntülerini incele.
2. Windows'ta açılış ve fiziksel gamepad kontrolünü yap; bulguları #12'ye ekle.
3. Beş oyuncuyla ilk his testini uygula; kayıt şablonu VALIDATION.md'de.
4. Kontrol/vuruş sorunlarını düzelt, ilgili testleri tekrar çalıştır.
5. Faz 1 çıkış kapısı geçince Faz 2'de ikinci silah, ilk boss ve sanat denemesine başla.

## Tahmin kuralı

PRD'deki 16–22 hafta MVP tahmini, iki geliştirici ve bir sanatçının tam zamanlı kapasitesine bağlı ilk varsayımdır. Bu repo güncellemesi o takvime yönelik teslim garantisi değildir. Her faz sonunda gerçek kapasite ve içerik üretim süresiyle güncellenir.
