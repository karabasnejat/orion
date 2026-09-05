# Orion — Kül Yemini

Özgün, karanlık fantastik **2D aksiyon roguelite**. Godot **4.5.1 Standard / GDScript** ile geliştiriliyor.

Bu dal, **Faz 0 proje temeli + Faz 1 dövüş prototipini** içerir. Oynanabilir üç salonlu test arenası, beş düşman ve bir çıkış mührü vardır. Tam MVP henüz değildir.

## Çalıştırma

1. [Godot 4.5.1 Standard](https://github.com/godotengine/godot/releases/tag/4.5.1-stable) sürümünü indir.
2. Bu repoyu klonla ve `codex/phase-1-combat-prototype` dalını aç (PR birleştikten sonra `main`).
3. Godot Project Manager → **Import** → repodaki `project.godot`.
4. **F6 yerine F5** ile ana projeyi çalıştır; başlangıç ekranında yeminini seç ve **Ocağı terk et** düğmesine bas.

Komut satırı: `godot --path .` (`godot` yerine yerel Godot çalıştırılabilir dosyanın yolunu kullan).

Ek paket, .NET, sunucu, API anahtarı veya dış sanat dosyası gerekmez. Geçici görseller kodla çizilir; sesler yerel olarak sentezlenir.

## Kontroller

| Eylem | Klavye | Gamepad (Xbox düzeni) |
|---|---|---|
| Hareket | A/D veya yönler | Sol çubuk / D-pad |
| Zıpla / çift zıpla | Space | A |
| İnce platformdan in | Aşağı + Space | Aşağı + A |
| Hafif / ağır saldırı | J / K | X / Y |
| Kaçış | Shift | B |
| İyileşme | E | LB |
| Duraklat | Esc | Menu |

Hafif komboyu sürdürmek için toparlanmanın sonuna yakın tekrar vur. Ağır saldırı vuruşa başladıktan sonra kaçışla iptal edilemez. Şifa 0,7 sn sürer; darbe alırsan yük harcanmadan kesilir.

**Avcı Yemini:** kaçışın ilk 100 ms'sinde saldırıyla çakışmak, 2 sn içindeki ilk isabeti ×1,5 güçlendirir. Bedeli: kaçış tekrar süresi 0,65→0,8 sn. Başlangıçta yeminsiz oynanabilir.

## Şu anda bulunanlar

- 240 px/sn hareket, çift zıplama, 100 ms coyote, 120 ms giriş tamponu.
- 96 px kaçış, 150 ms dokunulmazlık, hava kaçışı sınırı, duvar çarpışması.
- Veri dosyasından üç darbeli kılıç ve ağır saldırı; tek hedefe tek hasar.
- Nöbetçi ve okçu, ön işaretler, sendeleme, duvarda durabilen mermiler.
- 100 can, iki şifa, ölüm/yeniden başlama, arena temizliği ve çıkış.
- Klavye/gamepad eşleme, duraklatma, odak/bağlantı kaybı davranışı.
- Ayarlanabilir ses ve kamera sarsıntısı; isteğe bağlı yerel test günlüğü.

Henüz yok: boss, diğer silahlar/yeminler, aktif yetenek, rastgele harita, eşya ekonomisi, sefer kaydı, tam yerelleştirme, yeniden tuş atama ve yardım modu. Bunlar [faz planında](docs/ROADMAP.md) takip edilir. Geçici sanat ve ses nihai ürün kalitesini temsil etmez.

## Test

Linux/macOS, Godot ve ripgrep PATH üzerindeyken:

```bash
GODOT_BIN=godot tests/check.sh
```

Windows'ta aynı doğrulama komutları (çalıştırılabilir dosya adını kurulumuna göre değiştir):

```powershell
Godot_v4.5.1-stable_win64_console.exe --headless --path . --editor --import --quit
Godot_v4.5.1-stable_win64_console.exe --headless --path . --fixed-fps 60 --script tests/run_tests.gd
```

İlk komut sınıf önbelleğini üretir. İkinci komut testleri gerçek Godot fizik dünyasında çalıştırır. `ORION TEST RESULT` satırı ve sıfır çıkış kodu beklenir; `SCRIPT ERROR` çıktısı başarılı kabul edilmez. CI ayrıca gerçek renderer ile menü ve arena görüntüleri oluşturur.

İnsan oyun hissi testi, fiziksel gamepad kontrolü ve Windows çalıştırma kontrolü otomatik testlerden ayrıdır: [doğrulama kaydı](docs/VALIDATION.md).

## Dokümanlar

- [PRD](docs/PRD.md)
- [Fazlar ve GitHub görevleri](docs/ROADMAP.md)
- [Mimari ve teknik kararlar](docs/ARCHITECTURE.md)
- [Doğrulama ve manuel oyun testi](docs/VALIDATION.md)
- [Katkı kuralları](CONTRIBUTING.md)

Yerel test günlüğü yalnızca başlangıç ekranında açılır; ağ isteği yapılmaz. Godot `user://playtest.jsonl` konumuna yazılır. Profil/sefer kaydı değildir. Günlük kapalıyken oynanış olayları diske yazılmaz.
