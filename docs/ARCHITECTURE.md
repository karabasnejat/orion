# Faz 1 mimarisi

## Kararlar

- **Motor:** Godot 4.5.1 Standard; GDScript. Özel derleme veya eklenti yok.
- **Oyun alanı:** 640×360 mantıksal çözünürlük, varsayılan pencere 1280×720, 60 Hz fizik.
- **Dünya:** ilk his testi için elle kurulmuş üç salon ve beş düşman. PRD'deki rastgele üretici Faz 3'e ait.
- **Sanat:** orijinal kodla çizilen geçici şekiller. Nihai animasyon/tileset üretimi Faz 2'de.
- **Ses:** üç kısa sentezlenmiş vurgu. Nihai miks ve müzik Faz 2'de.
- **İlerleme:** bu prototipte yalnızca arena sonucu; profil veya sefer kaydı yok.

## Modüller

| Dosya | Sorumluluk |
|---|---|
| `arena.gd` | Statik dünya, düşman başlangıçları, kamera, arena sonucu ve görsel parçacıklar |
| `player.gd` | CharacterBody2D hareketi, giriş tamponu, kaçış, iyileşme, kılıç ve yemin |
| `attack.gd` | Saldırı pencereleri ve saldırı başına hedef kimliği defteri |
| `enemy.gd` | Nöbetçi/okçu durumları; ön işaret, saldırı, toparlanma ve sendeleme |
| `projectile.gd` | Her fizik adımında süpürülmüş ray ile dünya/oyuncu çarpışması |
| `hud.gd` | HUD, başlangıç/duraklatma/ölüm/zafer menüleri ve seçenekler |
| `input_setup.gd` | Klavye ve gamepad eylem eşlemeleri |
| `telemetry.gd` | İsteğe bağlı yerel JSONL; ağ yok |
| `audio_fx.gd` | Dört ses kanalı ve üç kısa sentezlenmiş vurgu |
| `sword.json` | Kombo hasarı, zamanlamalar ve menzil |

## Dövüş sırası

Fizik adımı → simülasyon sayaçları → giriş/eylem seçimi → CharacterBody hareketi → etkin saldırı kontrolü → hedef alanı → saldırı kimliği defteri → koşullu yemin → hasar/sendeleme/ölüm → sunum sinyali.

Ölü hedef hasar almaz. Aynı saldırı bir hedefe yalnızca bir kez vurur. Yemin güçlendirmesi ilk isabette harcanır; boşa savuruş güçlendirmeyi tüketmez. Normal hasar 700 ms bağışıklık verir; çevre hasarı kaçışı yok sayar. Boss sistemi henüz yoktur.

## Bilinçli sınırlar

Genel BuildSystem ve CombatResolver katmanları henüz ayrıştırılmadı: tek silah ve tek yemin için saldırı defteri ayrıldı; ikinci silah ve birden çok etki eklenirken Faz 2'de ortak çözümleyici çıkarılacak. Oda grafiği, veri migrasyonu ve ekonomi prototipe eklenmedi. Hit-stop ve nihai saldırı animasyonları his testinden sonra işlenecek; şu an ses, parıltı, parçacık ve sarsıntı geri bildirimi var.

CI indirilen Godot Linux arşivinin SHA-256 özetini sabitler. Testler Linux headless ortamında gerçek Godot sahne ağacı ve fizik üzerinden çalışır; bu sonuçlar Windows veya fiziksel kontrolcü testi yerine geçmez.
