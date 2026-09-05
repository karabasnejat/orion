# KÜL YEMİNİ — Ürün Gereksinimleri Dokümanı

Sürüm: 0.1 • Tarih: 5 Eylül 2026 • Durum: geliştirmeye temel oluşturan tasarım önerisi

## 1. Ürün özeti

**Kül Yemini**, çökmüş bir krallığın ölümsüz infazcısını yönettiğimiz, hızlı yakın dövüşe dayanan, yandan görünümlü bir 2D aksiyon roguelite oyunudur. Oyuncu her seferde değişen oda düzenlerinden geçer, silah ve kalıntılarla bir dövüş yapısı kurar, hükümdarın muhafızlarını yenmeye çalışır. Öldüğünde seferdeki ekipmanını kaybeder; açtığı seçenekler ve öğrendiği düşman davranışları kalır.

Oyunun ayırt edici sistemi **Yeminler**dir. Oyuncu güçlü bir avantaj karşılığında oynayışını değiştiren açık bir bedel kabul eder. Örneğin son anda yapılan kaçış sonraki darbeyi güçlendirir, fakat kaçış bekleme süresini uzatır. Amaç yalnızca daha yüksek hasar toplamak değil, seçilen kurala uygun ustalık geliştirmektir.

Ürün vaadi: **“Her ölümde yeni bir beden; her yeminde başka bir savaş biçimi.”**

Bu doküman ürün gereksinimleriyle ilk dövüş ve içerik tasarımını birlikte kapsar. Belirtilen isimler çalışma adıdır. Sayısal denge değerleri, süreler, ekip ve başarı eşikleri test edilmemiş planlama varsayımlarıdır; gerçekleşmiş sonuç veya teslim taahhüdü değildir.

## 2. Başlangıç kararları ve varsayımlar

| Konu | Önerilen karar | Gerekçe / doğrulama |
|---|---|---|
| İlk platform | Windows PC, çevrimdışı tek oyuncu | İlk teslimat yüzeyini daraltmak |
| Kontroller | Klavye ve gamepad; ikisi de tam işlevli | Aksiyonun farklı giriş cihazlarında aynı kurallarla çalışması |
| Görünüm | 2D yandan görünüm, stilize piksel sanat | Silüet ve vuruş okunabilirliği |
| Motor | Godot 4.x, GDScript; sürüm prototip başında sabitlenir | Yerleşik 2D araçları; kısa prototiple ekip verimliliği doğrulanır |
| Sefer süresi | MVP 12–18 dakika; 1.0 25–40 dakika | Kısa tekrar döngüsü |
| İş modeli | Tek satın alım; fiyat henüz belirlenmedi | Çevrimdışı tamamlanmış oyun hedefi |
| İlk diller | Türkçe ve İngilizce | Metinler baştan yerelleştirme anahtarlarıyla tutulur |
| Ekip varsayımı | 2 geliştirici, 1 sanatçı/animatör; tasarım ve QA ortak, ses dönemsel | Takvim bu kapasiteye bağlı |
| Bu çalışmanın çıktısı | PRD ve uygulanabilir geliştirme kapsamı | Oynanabilir oyun üretimi sonraki aşamadır |

Mobil, konsol, çok oyunculu, servis altyapısı ve tarayıcı dağıtımı ilk sürüm kapsamında değildir. Tarayıcı demosu istenirse ayrıca performans ve dışa aktarma denemesi yapılır; masaüstü kararı otomatik olarak değiştirilmez.

## 3. Hedef kitle ve ihtiyaç

Birincil oyuncu: refleks, düşman okumak ve silah ustalığından keyif alan; başarısız olduktan sonra farklı bir kurulum denemek isteyen aksiyon oyuncusu.

İkincil oyuncu: karanlık fantastik atmosferi seven, kısa seanslarla ilerlemek isteyen ve yardım seçenekleriyle zorluk seviyesini ayarlayan oyuncu.

Temel ihtiyaçlar:

- Bastığım tuşun sonucunu gecikmeden göreyim.
- Öldüğümde hangi saldırının ve kararımın buna yol açtığını anlayayım.
- Aynı bölgeyi yeniden oynarken farklı bir karar vermek zorunda kalayım.
- Yeni bir eşya gerçekten oynayışımı değiştirsin.
- Bir seferi yarıda bırakıp daha sonra devam edebileyim.

## 4. Tasarım ilkeleri ve sınırlar

1. **Önce dövüş hissi:** hareket ve tek silah eğlenceli olmadan içerik üretimi büyütülmez.
2. **Okunabilir tehlike:** normal düşmanların bütün hasarlı saldırılarının görsel ön işareti olur. Ses destekler, tek bilgi kanalı olamaz.
3. **Hızlı ama karar isteyen dövüş:** saldırıların toparlanma süresi ve kaçışın bekleme süresi vardır; sürekli tuş basmak her durumda güvenli değildir.
4. **Anlamlı güç bedeli:** yeminler avantajı ve dezavantajı aynı seçim kartında gösterir.
5. **Ölümden sonra seçenek:** kalıcı ilerleme yeni araçlar açar; zorunlu ve sınırsız stat kasma yoktur.
6. **Kontrollü rastgelelik:** odalar elle tasarlanır, bağlantıları ve karşılaşmaları kurallı üretilir.

Dead Cells, hareket/dövüş ritmi ve tekrar oynanabilir sefer yapısı için referanstır. Karakterler, haritalar, görseller, arayüz, müzik, hikâye, isimler ve eşya içerikleri özgün üretilir. Birebir içerik eşleme yapılmaz.

## 5. Dünya ve anlatı

Krallık, ölümü durdurmak için hükümdarın kalbini dev bir çanla bağlamıştır. Çanın her vuruşu ölüleri geri çağırırken yaşayanların anılarını siler. Oyuncu, son çan ustasını idam etmiş eski bir infazcıdır; kendi verdiği yemine bağlı olarak her ölümde ocakta yeniden oluşur.

Ana hedef: üç çan mührünü kırmak ve Kül Tahtı'na ulaşmak. Anlatının sorusu: ölümü geri getirmek kurtuluş mudur, yoksa ikinci bir katliam mı?

MVP anlatısı: Ocak'ta kısa bir konuşma, ilk bölgedeki 3 çevresel anlatı noktası ve ilk muhafızın yenilgisinden sonra bir kapanış metni. Final hikâyesi 1.0 kapsamındadır.

NPC rolleri:

| Karakter | İşlev | Kapsam |
|---|---|---|
| Kör Demirci | Silah tariflerini açar, eğitim alanına yönlendirir | MVP |
| Yemin Bekçisi | Yeminleri tanıtır; sefer başında seçim yaptırır | MVP |
| Kayıtçı | Bulunan anıları ve düşman bilgilerini gösterir | 1.0 |

Diyaloglar kısa ve atlanabilir olur. Ölüm sonrası aynı zorunlu konuşma tekrar gösterilmez. Tam seslendirme planlanmaz.

## 6. Ana oyun döngüsü

**Anlık döngü:** düşmanı oku → konum al → vur/kaç → açıklığı değerlendir → ödülü al.

**Sefer döngüsü:** Ocak → başlangıç silahı ve yemin → oda keşfi → eşya seçimi → riskli yan oda veya güvenli rota → muhafız → sonraki bölge → ölüm ya da zafer.

**Kalıcı döngü:** seferde kazanılan Kor'u sakla → Ocak'ta yeni seçenek aç → yeni kombinasyonla tekrar dene.

Ölümde kaybolanlar: sefer altını, ekipman, kalıntılar, o sefere özgü yükseltmeler. Kor, keşfedilmiş tarifler, hikâye kayıtları ve erişilebilirlik ayarları korunur. Kor sefer sırasında profile yazılır; ölmeden önce merkeze taşıma zorunluluğu yoktur.

Ölüm ekranı: öldüren saldırı, ulaşılan oda, kullanılan kurulum, kazanılan Kor ve “Tekrar başla” eylemi. Teknik yükleme hariç yeniden başlamaya en fazla iki onayla ulaşılır.

## 7. İlk 15 dakikanın tasarımı

| Zaman | Oyuncunun yaşadığı | Tasarım amacı |
|---|---|---|
| 0–1 dk | Ocak'ta uyanır; yürür ve zıplar | Kontrolü hemen vermek |
| 1–3 dk | Zararsız eğitim kuklasına saldırır, bir engelden kaçar | Saldırı ve kaçışı öğretmek |
| 3–5 dk | Tek kılıçlı düşman; belirgin ön işaret | Dövüş kuralını öğretmek |
| 5–7 dk | İlk kalıntı ve ilk yemin açıklaması | Kurulum kavramı |
| 7–10 dk | Menzilli düşman, platform ve opsiyonel ödül odası | Önceliklendirme ve risk |
| 10–15 dk | Elit karşılaşma; devam ederse muhafız | Ustalığı sınamak |

İlk eğitim düzeni sabittir; tamamlandıktan sonra atlanabilir. Ölüm yapay olarak zorunlu tutulmaz. Oyuncu ilk seferinde başarılı olabilmelidir.

## 8. Hareket, kamera ve giriş

Oyuncu sola/sağa koşar, zıplar, havada bir ek zıplama yapar, aşağı + zıplamayla tek yönlü platformdan iner ve yatay kaçış yapar. Çift zıplama başlangıçtan açıktır. Duvar koşusu, tırmanma ve kanca MVP'de yoktur.

Başlangıç ayarları: mantıksal çözünürlük 640×360; tipik zemin karosu 32 px; karakter yaklaşık 32×48 px. Fizik ve animasyon hitbox'ları görsel boyuttan ayrı ayarlanır.

| Parametre | İlk değer | Doğrulama |
|---|---:|---|
| Koşu hızı | 240 px/sn | Dar platformlarda hassas duruş |
| İlk zıplama yüksekliği | 96 px | Zorunlu geçitler güvenli payla erişilir |
| İkinci zıplama | 72 px ek yükseliş hedefi | Hareket simülasyonuyla erişilebilirlik |
| Coyote time | 100 ms | Kenardan yeni ayrılmış oyuncunun zıplayabilmesi |
| Giriş tamponu | 120 ms | Erken basılan zıplama/saldırıyı kaybetmemek |
| Kaçış mesafesi / süresi | 96 px / 250 ms | Düşman gövdesinden geçiş |
| Kaçış dokunulmazlığı | İlk 150 ms | Son bölümde cezalandırılabilirlik |
| Kaçış yeniden kullanım | Başlangıçtan 650 ms | Sürekli dokunulmazlığı önlemek |

Kaçış düşman gövdelerinden geçer, duvarlardan geçmez. Çukur/çevre hasarını engellemez. Hava kaçışı inişe kadar bir kez kullanılabilir. Hareket parametreleri çözünürlükten bağımsız oyun koordinatlarında hesaplanır.

Kamera yatay yönde hafif önden takip eder; dikey hareket yumuşatılır. Boss odasında arena sınırları kullanılır. Arayüz açıklamaları aktif dövüşü örtemez. Görüş dışındaki düşman, ön işareti ekrana girmeden saldırı başlatamaz.

| Eylem | Klavye varsayılanı | Gamepad varsayılanı |
|---|---|---|
| Hareket | A/D veya yönler | Sol analog / yön tuşları |
| Zıplama | Space | A / alt yüz tuşu |
| Hafif saldırı | J | X / sol yüz tuşu |
| Ağır saldırı | K | Y / üst yüz tuşu |
| Kaçış | Shift | B / sağ yüz tuşu |
| Aktif yetenek | Q | RB |
| İyileşme | E | LB |
| Etkileşim | F | Yukarı |
| Duraklat | Esc | Menu |

Tüm eylemler yeniden atanabilir. Çakışan bağlar uyarılır; kritik eylemin bağsız bırakılması engellenir. Takılı cihaz değişince simgeler güncellenir. Gamepad kopması ve pencere odak kaybı oyunu duraklatır.

## 9. Dövüş sistemi

### 9.1 Temel kurallar

Bir ana silah, o silaha bağlı hafif kombo ve ağır saldırı, bir aktif yetenek, en fazla üç kalıntı ve bir aktif yemin bulunur. İkinci silah değiştirme sistemi MVP'de yoktur.

Dayanıklılık çubuğu yoktur. Saldırı disiplini başlangıç, etkin vuruş ve toparlanma pencereleriyle sağlanır. Hafif saldırının toparlanması belirlenmiş bir andan sonra kaçışla iptal edilebilir. Ağır saldırı etkin kareler başlayana kadar kaçışla iptal edilebilir; vuruş başladıktan sonra toparlanması tamamlanır. Her silahın iptal pencereleri veri olarak tanımlanır.

Bir saldırı kimliği aynı hedefe bir kez hasar verir; çok vuruşlu saldırılar ayrı alt vuruş kimlikleri kullanır. Vuruş hacmi hedefe değmediyse hasar oluşmaz. Animasyon ile etkin vuruş penceresi eşleşir.

### 9.2 Başlangıç silahları

| Silah | Hafif zincir | Ağır saldırı | Güçlü yön | Bedel |
|---|---|---|---|---|
| İnfazcı Kılıcı | 3 darbe: 20/22/30 | 45 hasarlı geniş yay | Dengeli menzil ve hız | Belirgin uzmanlığı yok |
| Kül Hançerleri | 4 darbe: 10/10/12/20 | İleri atılan 28 hasarlı darbe | Hızlı tek hedef baskısı | Kısa menzil |
| Çan Çekici | 2 darbe: 35/50 | 70 hasarlı yer vuruşu | Sendeletme ve alan kontrolü | Uzun toparlanma |

Kılıç ilk darbe süresi için başlangıç: 100 ms hazırlık + 83 ms etkinlik + 183 ms toparlanma. Kaçışla iptal, toparlanmanın son 100 ms'sinde açılır. Bütün zamanlamalar hedef 60 Hz simülasyonda kare sınırlarına yuvarlanır.

MVP'de rastgele kritik vuruş yoktur. Kritikler yemin veya düşman durumu gibi açık koşullara bağlanır. Böylece hasar geri bildirimi açıklanabilir kalır.

### 9.3 Hasar ve durum etkileri

Başlangıç formülü:

`Doğrudan hasar = yuvarla(taban × silah seviyesi çarpanı × (1 + toplam ek hasar bonusu) × koşullu kritik × (1 − direnç))`

Silah seviyesi çarpanı seviye 1/2/3 için 1,00/1,15/1,30. Genel ek bonus toplamı ilk sürümde +%100 ile sınırlandırılır. Direnç 0–%50 aralığında tutulur. MVP'de oyuncuda rastgele zırh statı yoktur. Süreli hasar kritik üretemez, yeni süreli hasar veya öldürme zinciri tetiklemez; tetikleme döngüleri yasaktır.

| Durum | Kural | Kapsam |
|---|---|---|
| Yanma | 3 saniye boyunca saniyede 4 hasar; tekrar uygulama süreyi yeniler | MVP |
| Sendeleme | Eşik dolunca kısa hareket/saldırı kesilmesi; sonra 1 sn bağışıklık | MVP |
| Kanama | Hareket odaklı ikinci hasar sistemi | 1.0, doğrulama bekler |
| Donma/zehir | Ek efekt ve denge yükü | İlk sürüm dışı |

Normal düşmanın sendeleme eşiği 100; kılıç darbesi 25, çekiç darbesi 60 birim uygular. Boss normal sendelemeye bağışıktır; yalnızca önceden tanımlı faz sonu açıklıkları vardır. Oyuncu hasar alınca 700 ms temas/saldırı hasarı bağışıklığı kazanır; çukurdan kurtarma ayrı yürütülür. Geri itiş oyuncuyu kontrol edilemeyen uzun kilitlere sokmaz.

### 9.4 Vuruş hissi

Vuruşta kısa renk parlaması, yönlü parçacık, farklı malzeme sesi ve hafif titreşim kullanılır. Hit-stop hafif darbede 35 ms, ağır darbede 60 ms başlangıç değerindedir. Global hit-stop üst üste biriktirilmez; en uzun kalan pencere uygulanır. Girişler bu sırada tamponlanır. Simülasyon zamanına bağlı süreler birlikte durur; UI animasyonları bağımsız kalabilir.

Kamera sarsıntısı, titreşim ve parlamalar ayrı ayrı kapatılabilir. Güçlü efektler düşman saldırı işaretini örtmez.

### 9.5 Aktif yetenek ve iyileşme

MVP yetenekleri: Köz Dalgası (önde kısa alan hasarı, 8 sn bekleme), Zincir Mührü (normal düşmanı kısa sabitleme, 10 sn), Kül Patlaması (yakın çevrede itme, 12 sn). Boss sabitlemeden etkilenmez; bunun yerine düşük doğrudan hasar alır ve bu kartta belirtilir.

Oyuncu 100 can ve 2 iyileşme yüküyle başlar. Her yük 40 can verir; kullanım 700 ms sürer, hareketi durdurur, hasarla kesilir. Yük ancak kullanım başarıyla bittiğinde tüketilir. Boss öncesinde MVP'de bir kez 1 yük yenilenir; kapasite aşılmaz. Can tamken kullanım engellenir.

## 10. Yemin sistemi: özgün ürün mekaniği

MVP'de sefer başında tek yemin seçilir ve sefer bitene kadar değişmez. Eğitimde ilk yemin açıklaması atlanabilir. İlk profil için üç yemin de açıktır; oyuncu isterse yeminsiz oynayabilir. Yemin seçimi yapmamak temel dövüşü cezalandırmaz.

| Yemin | Avantaj | Bedel | Teşvik edilen davranış |
|---|---|---|---|
| Köz Yemini | Hafif zincirin son darbesi yakar | Maksimum can 100→85 | Zinciri güvenli açıklıkta tamamlamak |
| Avcı Yemini | Son anda kaçıştan sonraki 2 sn içindeki ilk darbe ×1,5 | Kaçış yeniden kullanım 650→800 ms | Tehdidi okuyarak kaçmak |
| Çan Yemini | Ağır saldırı sendeletmesi +%50 | Ağır saldırı toparlanması +%20 | Konum ve zamanlama |

“Son anda kaçış”: dokunulmazlığın ilk 100 ms'sinde düşman saldırı hacminin oyuncunun incinebilir alanıyla çakışması. Her kaçış en fazla bir güçlendirme üretir. Çevre tuzakları tetiklemez. Kullanılmayan güçlendirme 2 sn sonra silinir; birikmez.

1.0'da toplam 6 yemin hedeflenir; MVP verisi görülmeden yeni yeminler kilitlenmez. Aynı anda iki yemin, rastgele yemin cezaları ve kalıcı yemin kaybı kapsam dışıdır.

Kabul koşulu: oyuncu seçim ekranında avantajı, bedeli ve değişen sayıları görür; seçimden sonra HUD simgesinden aynı bilgiye dönebilir. İlk testte 10 oyuncunun en az 8'i seçtiği yeminin bedelini doğru anlatabilmelidir.

## 11. Ekipman, kalıntılar ve sefer içi ilerleme

Ödül odalarında oyuncuya üç kart sunulur ve biri alınır. Oyun seçim sırasında durur. Silah kartı mevcut silahla karşılaştırılır; değiştirme eski silahı yere bırakır. Kalıntı yuvaları doluysa değiştirilecek kalıntı ayrıca seçilir. Oyuncu seçimi iptal edip yürüyebilir.

MVP'de 3 silah, 3 aktif yetenek ve 9 kalıntı vardır. Nadirlik katmanı yoktur; farklı renkler güç kademesi sanılacak şekilde kullanılmaz. Silah seviyesi ve kalıntı etkisi açık yazılır.

| Kalıntı | İlk tasarım etkisi |
|---|---|
| Köz Halkası | Yanma süresi +1 sn |
| Avcı Dişi | Son anda kaçış güçlendirmesi aktifken hareket +%10 |
| Çatlak Çan | Sendelemiş normal düşmana doğrudan hasar +%20 |
| Savaşçı Bezi | Maksimum can +15; kazanıldığında 15 can da ekler |
| Ocak Külü | İyileşme miktarı 40→50 |
| Zincir Parçası | Aktif yetenek bekleme süresi −%10 |
| Keskin Taş | Hafif zincirin son darbesi +%15 hasar |
| Kurşun Mühür | Ağır saldırı +%15 hasar; hareket −%5 |
| Kor Kesesi | Sonraki Kor kazanımları +%20; geriye dönük uygulanmaz |

Aynı kalıntının ikinci kopyası sunulmaz. Etkiler kararlı kimliklerle bağlanır. Sinerji etiketleri: yanma, kaçış, ağır saldırı, iyileşme, ekonomi. Ödülün en az bir seçeneği mevcut silahla işlevsel olmalıdır; oyuncuyu tek bir kuruluma zorlayan tam sinerji garantisi verilmez.

MVP'de her seferde iki garanti kalıntı seçimi ve boss öncesinde bir silah seviye yükseltmesi bulunur. Yan odalar üçüncü kalıntı veya alışveriş fırsatı sunar. Girişte bütün açılmış temel silahlar seçilebilir; açılan seçenekler rastgele havuzu kötüleştirmez.

## 12. Ekonomi ve kalıcı ilerleme

**Altın:** yalnızca sefer içinde kullanılır. **Kor:** kalıcı açılımlar için kullanılır. Üçüncü para birimi yoktur.

İlk denge tablosu: normal düşman 4–6 altın, elit 20, yan sandık 15. Tüccarda iyileşme yükü 35, kalıntı 50, silah yükseltmesi 60 altın. Alımlar tek stoktur; fiyat tekrar tekrar yenilenmez. Zorunlu boss öncesi yükseltme ücretsizdir; tüccar yükseltmesi aynı silahı en fazla seviye 3'e taşır.

Kor kazanımı: tamamlanan savaş odası +2, elit +4 ek, boss +15. Ocak'a dönüşte ayrıca tekrar hesaplanmaz. Kor veren oda/karşılaşma kimliği kaydedilerek yükleme yoluyla çoğaltma engellenir.

Açılımlar: hançer 15 Kor, çekiç 25 Kor, ek yetenek seçeneklerinin her biri 20 Kor. Kılıç ve bir yetenek başlangıçta açıktır. Kalıntılar MVP'de baştan havuzdadır. İlk tam sefer 5–7 ödüllü savaş odası ve boss ile yaklaşık 25–29 Kor üretir; elit varsa ek ödül kazanılır. Bu varsayım testte ayarlanır.

Kalıcı hasar ve can ağacı yoktur. Beceri kazanımı oyunun ana ilerlemesidir. 1.0'da isteğe bağlı güzergâh anahtarları eklenebilir; bunlar MVP'nin zorunlu üretim kuralını değiştirmez.

## 13. Bölüm üretimi ve rota

MVP bölgesi **Kül Zindanları**: yıkık fırınlar, demir kafesler, sönmüş nöbet kuleleri. Bölüm, elle hazırlanmış oda şablonlarının kurallı bir grafikte birleştirilmesidir.

MVP içerik havuzu: 12 savaş, 4 geçiş/platform, 3 ödül/yan meydan okuma, 1 tüccar, 1 güvenli giriş ve 1 boss odası olmak üzere **22 şablon**. Bir seferde bunların 10–12'si kullanılır; bütün havuz tek seferde tüketilmez. Ödül seçimleri savaş sonrası çıkış alanlarına da yerleşebilir.

Üretim sırası:

1. Tohumu oluştur; üretici sürümüyle kaydet.
2. 8–9 odalık zorunlu ana yol kur: giriş, en az 5 savaş, güvenli hazırlık, boss; gerekirse bir geçiş.
3. 2–3 yan oda ekle; en az bir ödül, bir tüccar garantile.
4. Kapı yüksekliği ve yön etiketleri uyumlu şablonları yerleştir.
5. Karşılaşma bütçesini ve ödül noktalarını doldur.
6. Girişten boss'a erişimi, hareket sınırlarını ve kilit kurallarını doğrula.
7. Üretim 20 denemede geçmezse doğrulanmış sabit düzene dön; sebebi günlüğe yaz.

Oda geçişi yükleme kapılarıyla yapılır; kesintisiz birleşik harita zorunlu değildir. Zorunlu kapı açmak için gereken düşmanların tamamı erişilebilir alanda doğar. Platformlar, çift zıplama ve kaçışla doğrulanmış mesafeleri aşmaz. Zorunlu yolda hasar almak şart değildir. Ödül odası çıkışı kilitlenmez.

İlk iki savaş odasında uzaktan ve yakın düşman aynı anda baskı yapmaz. Aynı şablon bir seferde tekrar edilmez; art arda aynı düşman kompozisyonu verilmez. Tuzaklar kapı varış noktasından güvenli mesafede tutulur. Çukur oyuncuyu son güvenli zemine geri koyar ve maksimum canın %10'u hasar verir; sonsuz düşüş engellenir.

1.0 güzergâhı: Kül Zindanları → Paslı Su Yolları veya Dilsiz Manastır → Çan Kulesi → Kül Tahtı. Toplam 5 bölge vardır; tek sefer 4 bölge ziyaret eder. Her ziyaret edilen bölge bir boss ile biter; 1.0 hedefi toplam 5 boss tasarımıdır.

## 14. Düşman ve karşılaşma tasarımı

| Düşman | Rol | Okunabilir işaret | Karşı oyun | Başlangıç can/hasar |
|---|---|---|---|---|
| Kül Nöbetçisi | Yakın baskı | Kılıcı 450 ms geri çeker | Arkaya kaç, toparlanmada vur | 60 / 12 |
| Çan Okçusu | Mesafe | Nişan çizgisi ve 650 ms kurma | Zıpla, yaklaş, görüşü kes | 40 / 10 |
| Zincirli | Alan tehdidi | Zinciri 700 ms döndürür | Menzil dışına çık | 100 / 18 |
| Köz Sıçanı | Hareket | 400 ms çömelip atılır | Atlayışı boşa çıkar | 25 / 8 |
| Mum Taşıyıcı | Destek | 1 sn güçlendirme ritüeli | Önce destekçiyi yen | 45 / 6 |
| Kırık Muhafız | Savunma | Ön kalkan ve açık sırt | Arkaya geç veya ağır vur | 80 / 14 |

Elit ayrı bir görsel varyanttır: normal can ×1,6, hasar ×1,2 ve yalnızca tek ek saldırı özelliği. Ön işaret süreleri kısalmaz. MVP'de iki elit varyantı vardır.

AI durumları: bekleme → fark etme → yaklaşma/konum → hazırlık → saldırı → toparlanma; kesintiler: sendeleme ve ölüm. Hedef kaybolunca düşman sonsuza kadar duvara koşmaz. Uçurumdan düşen veya harita dışında kalan son düşman temizlenir; oda kilidi çözülebilir kalır.

Karşılaşma bütçesi: sıçan 1, nöbetçi/okçu 2, destekçi/kalkanlı 3, zincirli 4 puan. İlk odalar 3–5, orta 6–8, geç odalar 8–11 puan. Aynı anda en fazla 6 normal düşman; en fazla 2 yakın düşman saldırı hazırlığına girebilir, menzilli atışlar ayrıca yönetilir. Testte birden çok saldırının kaçışı imkânsız kıldığı kombinasyonlar yasaklanır.

## 15. MVP boss: Çan Celladı

Arena: tek ekran genişliğine yakın ana zemin, iki kısa platform; zorunlu çukur yok. Başlangıç canı 1.200; hedef dövüş süresi, başlangıç ekipmanında 90–150 sn.

| Saldırı | İşaret | Etki | Güvenli cevap |
|---|---|---|---|
| Yatay infaz | 650 ms omuz germe | Öne geniş balta yayı | Arkaya kaç |
| Çan darbesi | 900 ms baltayı kaldırma | Zeminde hareketli dalga | Zıpla |
| Zincir çekişi | 750 ms çizgisel hedef | Oyuncunun önceki konumuna çekiş | İşaretten sonra yer değiştir |
| Kül yağmuru | 1.100 ms çan titreşimi ve zemin işaretleri | Sırayla düşen 3 alan saldırısı | İşaretler arasına geç |

Can %50'ye düşünce ikinci faz başlar. Kısa geçişte boss hasar almaz; efektle açıkça belirtilir. Ön işaretler korunur, saldırı sırası çeşitlenir ve kül yağmuru eklenir. Aynı anda güvenli alanı kapatan saldırılar üst üste binmez. Her büyük saldırıdan sonra 600–900 ms cezalandırma açıklığı bulunur.

Ölüm ve zafer aynı simülasyon adımında olursa boss ölümü sefer zaferi olarak işlenir; ödül ve tamamlanma yalnızca bir kez yazılır. Boss arenasına girişten önce çıkış kaydı alınır; dövüş sırasında manuel kayıt yoktur.

## 16. Kullanıcı arayüzü ve erişilebilirlik

Ekranlar: ana menü, profil/devam, ayarlar, Ocak, oyun HUD, eşya karşılaştırma, yemin seçimi, duraklatma, ölüm ve zafer. MVP'de tek yerel profil; silme eylemi açık onay ister.

HUD: sol üstte can ve iyileşme yükleri; alt köşede yetenek beklemesi ve yemin; sağ üstte sefer altını; boss canı üst orta. Kor artışı kısa bildirimle gösterilir. Envanter ve harita açıldığında tek oyunculu oyun durur.

Erişilebilirlik gereksinimleri:

- Metin ölçeği %100/%125/%150; 1280×720'de taşma olmamalı.
- Hasar göstergelerinde renk yanında şekil/ikon; düşman saldırısı yalnızca sese bağlı değil.
- Kamera sarsıntısı, parlamalar, titreşim ve hasar sayıları ayarlanabilir.
- Basılı tutarak hafif saldırı tekrarı, manuel girişten yüksek hız vermez.
- Yardım modu: alınan hasar %50/%75/%100, oyun hızı %75/%90/%100. Bu modlar simülasyon zamanı üzerinden tutarlı uygulanır.
- Yardım modu istediği anda açılabilir; ilerlemeyi ve bitişi engellemez. Analiz sonuçlarında ayrı segmentlenir.

MVP haritası oda düğümleri ve bağlantılarını gösterir; ayrıntılı minimap gerektirmez. Görülmemiş yan oda içeriği açıklanmaz. Ödül açıklamalarında yalnızca anlatı değil, sayısal etki de bulunur.

## 17. Görsel sanat ve ses

Renk yönü: kömür grisi çevre, soluk kemik karakter detayları, sıcak turuncu oyuncu ateşi, mor/magenta düşman büyüsü. Düşman saldırıları çevre ışığından değer ve şekil olarak ayrılır. Ön plan dekoru savaş alanını örtmez.

Üretim yaklaşımı: tek karakter gövdesi, üç ayrı silah animasyon seti; düşmanlarda ortak teknik iskelet kullanılabilir fakat silüetler ayrı tutulur. MVP karakter durumları: idle, koşu, zıplama, düşüş, iniş, kaçış, hafif zincir, ağır saldırı, yetenek, iyileşme, darbe ve ölüm. Her saldırı için hazırlık/etkinlik/toparlanma doğrulaması yapılır.

MVP varlık bütçesi: 1 bölge tileset'i, 3 arka plan katmanı, 6 düşman, 2 elit varyantı, 1 boss, 3 silah, 3 yetenek efekti, 9 kalıntı simgesi, 3 yemin simgesi. Animasyon kare sayıları görsel denemeden sonra kilitlenir.

Ses: her silah için savurma/vuruş seti; düşman ön işaretleri; can azlığı; iyileşme; ödül; boss fazı. Müzik için Ocak, bölge ve boss olmak üzere 3 döngü hedeflenir. Ses, efekt ve müzik ayrı seviyelere sahiptir. Aynı sesin aşırı çoğalmasını önlemek için eşzamanlı ses limiti tanımlanır.

## 18. Teknik mimari

Motor kararı: Godot'un özel 2D renderer, fizik, tilemap, parçacık ve animasyon araçları bu ürünün temel ihtiyaçlarıyla örtüşür [S2]. GDScript seçimi ekip için başlangıç önerisidir; motor sürümü ve kodlama standardı ilk prototipte sabitlenir. Çevrimdışı MVP için API, veritabanı sunucusu veya LLM çağrısı gerekmez.

| Modül | Sorumluluk | Sınır |
|---|---|---|
| PlayerController | Hareket, giriş tamponu, durum geçişleri | Ödül/ekonomi yönetmez |
| CombatResolver | Hitbox, hasar, bağışıklık, tetikleme sırası | Animasyon çizmez |
| EnemyController | AI ve saldırı durumları | Sefer kayıtlarını yazmaz |
| RunDirector | Tohum, oda ilerlemesi, sefer sonucu | Silah hasarını hesaplamaz |
| RoomGenerator | Şablon grafiği ve doğrulama | Kalıcı profil değiştirmez |
| BuildSystem | Silah, yemin, kalıntı etkileri | Veri kimliklerini kullanır |
| SaveService | Atomik kayıt, yedek, sürüm geçişi | Tek yazıcıdır |
| UI/Audio | Olaylara göre sunum | Oyun kuralının kaynağı değildir |
| Telemetry | Yerel test olayları | Ağ bağlantısı zorunlu kılmaz |

Veriler Godot Resource veya doğrulanan JSON olarak tanımlanır. Silah şeması: id, localization_key, combo_steps, damage, timings, hitbox, cancel_windows, stagger, tags. Yemin şeması: id, trigger, benefit, cost, cooldown, stacking_policy. Oda şeması: id, biome, sockets, bounds, spawn_points, encounter_budget, safe_zones.

Her içerik kimliği kalıcıdır; dosya adının değişmesi kaydı bozmaz. Veri doğrulayıcı eksik metin anahtarı, negatif süre, kayıp sahne ve döngüsel tetiklemeyi yakalar. Rastgelelik; harita, karşılaşma ve ödül için ayrı akışlara ayrılır. Aynı sürüm+tohum aynı yerleşimi üretir; bütün fizik simülasyonunun platformlar arası deterministik olması beklenmez.

Hasar işleme sırası: çakışma → saldırı kimliği tekrar kontrolü → dokunulmazlık → temel/koşullu hesap → can düşürme → ölüm ya da darbe → durum etkisi → tek seferlik ödül → görsel olay. Ölmüş hedef yeni durum almaz.

## 19. Kayıt ve devam davranışı

Profil: şema sürümü, Kor bakiyesi, açılmış içerikler, tamamlanan eğitim, ayarlar ve hikâye bayrakları. Sefer kaydı: run_id, tohum, üretici sürümü, oda grafiği, tamamlanan oda kimlikleri, mevcut oda giriş durumu, can, yükler, ekipman, altın, verilmiş Kor ödülleri.

Normal çıkışta en son oda girişinden devam edilir; oda içi düşmanların anlık konumları saklanmaz. Çıkışta arayüz bunu açıkça söyler. Tamamlanmış odalar tamamlanmış kalır; temizlenen odaya dönüş ödül yaratmaz. Ölüm hemen seferi kapatır; devam menüsü eski seferi göstermez.

Kor işlemleri ve sefer durumu tek sürümlü kayıt paketi içinde güncellenir. Önce geçici dosyaya yazılır, doğrulanır, sonra atomik değiştirilir; son sağlam yedek korunur. Bozuk kayıt varsa yedek yüklenir ve kullanıcı bilgilendirilir; sessizce profil sıfırlanmaz. Disk yazılamıyorsa duraklatma ekranında açık hata ve yeniden dene seçeneği bulunur.

Oyun güncellemesi seferi uyumsuz hale getirirse profil korunur, sefer kapatılmadan önce bilgi gösterilir. 1.0 öncesi şema geçişleri eski test kayıtlarıyla doğrulanır. Bulut kayıt MVP dışında kalır.

## 20. Performans ve kalite gereksinimleri

Bütün donanım değerleri hedef test matrisi içindir; yayımlanmış minimum sistem gereksinimi sayılmaz.

| Ölçüm | Kabul hedefi | Test koşulu |
|---|---|---|
| Kare hızı | 1080p'de 60 FPS; kare süresi p95 ≤16,7 ms, p99 ≤25 ms | Ryzen 5 3500U / Vega 8 / 8 GB, düşük efekt profili; 10 dk yoğun sahne |
| Giriş işleme | Giriş olayından durum değişimine ≤2 fizik adımı | 60 Hz, oyun içi zaman damgası; ekran gecikmesini kapsamaz |
| Açılış | ≤10 sn | SSD, yayın derlemesi |
| Oda geçişi | ≤2 sn | Ön yükleme sonrası aynı cihaz |
| Yeniden başlama | ≤5 sn yükleme | Ölüm ekranı onayı sonrası |
| Bellek | 1,5 GB altında süreç belleği | 30 dk tekrar sefer |
| Kararlılık | Yayın kapısında kritik çökme yok | 20 saat yapılandırılmış oynanış + kayıt senaryoları |

1080p, 1440p ve 720p test edilir. Oyun alanı en-boy oranıyla haksız görüş avantajı yaratmaz; gerekli durumda kenar boşluğu kullanılır. Duraklatma AI, mermi, bekleme ve hasar zamanlayıcılarını birlikte durdurur.

## 21. Kapsam basamakları

P0: basamağın çıkışı için zorunlu. P1: çekirdek doğrulandıktan sonra. P2: sonraki sürüm.

| İçerik / sistem | Dövüş prototipi | Vertical slice | MVP | 1.0 hedefi |
|---|---:|---:|---:|---:|
| Bölge | Test alanı | 1 kısmi | 1 | 5 |
| Oda şablonu | 3 | 8 | 22 | 70–90 |
| Silah | 1 | 2 | 3 | 10 |
| Normal düşman | 2 | 3 | 6 | 18 |
| Elit varyantı | 0 | 1 | 2 | 6 |
| Boss | 0 | 1 | 1 | 5 |
| Yemin | 1 | 3 | 3 | 6 |
| Aktif yetenek | 1 | 2 | 3 | 8 |
| Kalıntı | 0 | 4 | 9 | 24 |
| Kalıcı ilerleme | Yok | Basit | Tam temel döngü | Genişletilmiş seçenekler |
| Kayıt/devam | Ayarlar | Profil | Profil + sefer | Sürüm geçişleriyle |

Vertical slice: oyunun hedef hissini temsil eden, kısıtlı ama görsel/ses olarak işlenmiş kısa kesit. MVP: yeni bir oyuncunun dış yardım olmadan başlayıp seferi tamamlayabildiği, kayıtlı ve tekrar oynanabilir test ürünü. MVP, 1.0'ın satışa hazır olduğu anlamına gelmez.

P0 MVP: hareket, üç silah, yeminler, boss, kurallı üretim, ödül/ekonomi, kayıt, iki kontrol türü, temel erişilebilirlik. P1: ek dekor, ayrıntılı düşman ansiklopedisi, gelişmiş menü animasyonları. P2: günlük sefer, skor tablosu, boss rush, konsol, atölye/mod desteği.

## 22. Kullanıcı hikâyeleri ve kabul koşulları

| ID | Gereksinim | Doğrulanabilir kabul koşulu |
|---|---|---|
| MOV-01 | Oyuncu hassas hareket eder | Kenardan ayrıldıktan ≤100 ms sonra zıplama kabul edilir; daha geç giriş kabul edilmez |
| COM-01 | Vuruş tutarlıdır | Tek vuruşun 10 kare örtüşmesi tek hasar olayı üretir |
| COM-02 | Kaçışın bedeli vardır | Dokunulmazlık dışında aynı çakışma hasar verir; duvardan geçiş olmaz |
| COM-03 | Saldırılar okunabilir | Her düşman saldırısı görünür ön işaret ve ölçülen hazırlık süresine sahiptir |
| OAT-01 | Yemin etkisi anlaşılır | Kart, HUD ve gerçek stat hesapları aynı avantaj/bedeli gösterir |
| OAT-02 | Son anda kaçış kötüye kullanılamaz | Tek kaçış, çok hedef olsa da tek güçlendirme yaratır |
| LOOT-01 | Ödül seçimi geri alınabilir | Kart incelemesi eşya tüketmez; onay tek öğe verir |
| GEN-01 | Her sefer tamamlanabilir | 1.000 tohumda boss'a erişim ve zorunlu zıplama denetimi geçer |
| ECO-01 | Ödül çoğaltılamaz | Oda çıkış/giriş/yükleme tekrarında Kor ve altın yeniden verilmez |
| SAV-01 | Kayıt korunur | Yazma sırasında kesinti sonrası son sağlam paket veya yedek açılır |
| UX-01 | Oyun kendi kendini öğretir | 10 yeni oyuncunun ≥8'i ilk ödüle moderatör yardımı olmadan ulaşır |
| ACC-01 | Yardım modu tamdır | Düşman hasarı, tuzak hasarı ve oyun zamanı seçilen kurala uyar |
| BOS-01 | Zafer tektir | Aynı karede boss ve oyuncu ölümü bir zafer ve tek ödül üretir |
| RUN-01 | Devam çalışır | Yeniden açılışta en son oda girişindeki ekipman/can/altın doğru yüklenir |

## 23. Ölçüm ve oyun testi

İlk amaç oyuncuyu oyunda zorla tutmak değil, dövüşün ve kararların çalıştığını ölçmektir. Eşikler ürün hipotezidir; küçük örneklem ticari başarı kanıtı değildir.

Yerel olaylar: run_started, room_entered, room_cleared, damage_taken, player_died, item_selected, oath_selected, boss_started, boss_completed, run_completed. Ortak alanlar: build_version, anonim test oturumu, run_id, seed, oda kimliği, oyun süresi, input_device, assist_settings. Hasar olayları kaynak saldırı kimliğini içerir. Kişisel veri gerekmez; dışa aktarım testçinin bilgisiyle yapılır.

| Hipotez | Ölçüm | İlk eşik |
|---|---|---|
| Dövüş tatmin edici | 10 kişilik testte 1–5 puan | Medyan ≥4 |
| Ölüm anlaşılır | Ölüm sonrası “neden öldün?” yanıtı | ≥8/10 doğru kaynak ve kaçış yolu |
| Tekrar denemeye değer | İlk ölümden sonraki 60 sn'de gönüllü yeni sefer | ≥6/10; yönlendirme yapılmaz |
| Yeminler anlaşılır | Avantaj ve bedeli anlatma | ≥8/10 |
| Tek baskın seçenek yok | Silah/yemin seçimi ve başarı, benzer deneyim düzeyinde | Bir seçenek >%60 ise inceleme; otomatik nerf yok |
| Sefer ritmi uygun | Tamamlanan MVP sefer süresi | Medyan 12–18 dk |

Plan: prototipte 5 kişiyle his testi; slice'ta 10 yeni kişiyle ilk deneyim; MVP'de 20–30 kişiyle tekrar sefer ve denge testi. Yeni/deneyimli oyuncu, cihaz ve yardım modu ayrı incelenir. Küçük örneklem yüzdeleri yanında ham sayılar raporlanır.

## 24. QA planı ve çıkış kapıları

Otomasyon: hasar formülü, saldırı kimliği, süreli etki sınırları, yemin tetikleri, kayıt sürümleri ve 1.000 üretim tohumu. Statik graf denetimi yanında karakter hareketiyle kritik platform geçişleri doğrulanır.

Manuel: her silahla boss, gamepad çıkarma/takma, yeniden tuş atama, 720p büyük metin, efektler kapalı dövüş, oda temizlenirken duraklatma, disk yazma hatası, kayıt sırasında süreç kapanması, aynı karede ölüm/zafer ve harita dışına düşen düşman.

MVP çıkış kapısı:

- P0 kabul koşullarının tamamı geçti.
- İlerlemeyi durduran, kayıt bozan veya kontrolü kilitleyen açık hata yok.
- 20 saatlik QA oynanışı tamamlandı; bulunan kritik hatalar düzeltildi ve ilgili senaryolar tekrar geçti.
- En az 3 silah × 3 yemin kombinasyonuyla boss tamamlanabildi.
- İlk deneyim ve ölümün anlaşılabilirliği eşikleri karşılandı veya sorun için yeni tasarım ve tekrar test yapıldı.
- Perf hedefleri referans cihazda ölçüldü; tutmuyorsa efekt bütçesi azaltıldı veya donanım hedefi açıkça güncellendi.

## 25. Geliştirme planı ve bağımlılıklar

Takvim, belirtilen küçük ekibin tam zamanlı çalışması ve hazır içerik üretim deneyimi varsayımıyla **MVP için 16–22 hafta** tahminidir. Tek geliştiricide doğrudan bu takvim kullanılmaz; içerik kapasitesi ve haftalık zaman üzerinden yeniden planlanır. 1.0 için slice sonrası ayrı tahmin gerekir.

| Aşama | Süre | Çıktı | İlerlemenin koşulu |
|---|---:|---|---|
| Ön üretim | 1–2 hafta | Referans panosu, teknik spike, veri şemaları | Kontrol ve sanat yönü seçildi |
| Dövüş prototipi | 3–4 hafta | Hareket, tek silah, iki düşman, tek yemin | 5 kişilik his testinde temel sorun kalmadı |
| Vertical slice | 4–5 hafta | Kısa oynanış, ilk boss, hedef görsel/ses | İlk oyuncu testi ve performans ölçüldü |
| MVP üretimi | 5–7 hafta | 22 oda, tam MVP içerikleri, ekonomi/kayıt | Bütün P0 işlevler entegre |
| Denge ve sağlamlaştırma | 3–4 hafta | Oyun testleri, hata düzeltme, dağıtılabilir paket | MVP çıkış kapıları geçti |

Kritik yol: hareket → silah zamanlaması → düşman → yemin → boss → içerik ölçekleme. Kayıt şeması ve içerik kimlikleri slice öncesi kurulmalıdır. Oda üreticisi elle hazırlanan güvenilir odalar olmadan genişletilmez. Sanat üretimi oyuncu boyutu, hitbox ve hareket sınırları kilitlenmeden seri üretime geçmez.

Bütçe yaklaşımı: ekip haftası × gerçek haftalık maliyet + ses/lisans/QA giderleri + %20 belirsizlik payı. Ücret, dış hizmet teklifleri ve çalışma kapasitesi bilinmediğinden parasal toplam verilmez.

## 26. İlk iki sprint için uygulanabilir backlog

Sprint süresi 2 hafta varsayılmıştır; ilk iki sprint dövüş prototipine aittir.

| İş | Öncelik | Bağımlılık | Bitti sayılması |
|---|---|---|---|
| Proje, giriş eşleme, veri kimlikleri | P0 | Yok | Windows test paketi açılıyor; klavye/gamepad eylemleri geliyor |
| Koşu, iki zıplama, platformdan inme | P0 | Giriş | 3 test odasının geçişleri tamamlanıyor |
| Kaçış, tampon ve coyote time | P0 | Hareket | MOV-01 ve COM-02 geçiyor |
| Hitbox ve tek kılıç kombosu | P0 | Hareket | COM-01, iptal pencereleri ve animasyon eşleşmesi geçiyor |
| Nöbetçi AI ve hasar alma | P0 | Dövüş | Ön işaret→saldırı→toparlanma eksiksiz |
| Can, iyileşme ve ölüm/yeniden başla | P0 | Hasar | Boş yük kullanılamıyor; ölüm sonrası yeni sefer |
| Kamera ve vuruş geri bildirimi | P0 | Dövüş | Efekt açık/kapalı okunabilirlik kontrolü |
| Okçu ve karma karşılaşma | P0 | İlk düşman | Ekran dışı haksız atış yok |
| Avcı Yemini | P0 | Kaçış/hasar | OAT-02 ve gerçek stat etkileri geçiyor |
| Yerel test olayları | P0 | Sefer döngüsü | Ölüm nedeni ve süre dışa aktarılabiliyor |
| 5 kişilik his testi ve düzeltme | P0 | Önceki işler | Kayıtlı bulgular, öncelikli his düzeltmeleri |

İlk sprintin hedefi hareket+kılıç+nöbetçi; ikinci sprintin hedefi iyileşme, okçu, yemin ve his testidir. İş yükü sığmazsa görsel süsleme ertelenir; kontrol ve dövüş kabul koşulları çıkarılmaz.

## 27. Riskler ve kapsam kesme sırası

| Risk | Erken sinyal | Önlem |
|---|---|---|
| Dövüş hissi zayıf | Vuruş kaçırma hissi, yanlış iptal beklentisi | Yeni içerik durur; hitbox, tampon, zamanlama ayarlanır |
| İçerik üretimi yetişmez | Bir düşman/oda tahmini sürekli aşılır | Önce 1.0 içerik sayısı küçülür; MVP temel döngü korunur |
| Yeminler salt stat bonusuna dönüşür | Oyuncu davranışı seçimle değişmez | Tetik ve bedel yeniden tasarlanır |
| Rastgele harita sıkıcı veya kilitli | Benzer rota, erişilemez kapı | Şablon etiketleri, çeşitlilik kuralları ve sabit fallback |
| Kalıcı ilerleme grind yaratır | İlk silah açılımı birkaç başarısız seferde erişilemez | Kor kazanımı/bedeller yeniden dengelenir |
| Tek güçlü kurulum | Aynı seçim, farklı deneyim gruplarında baskın | Önce kullanım kolaylığı ve ödül sunumu incelenir |
| Kayıt hatası | Çift ödül, bozuk devam | Tek yazıcı, atomik paket, ödül kimliği |
| Sanat maliyeti | Silah başına animasyonlar darboğaz | Ortak gövde ve sınırlı hareket repertuvarı |

Takvim baskısında ilk kesilecekler: ek dekor, gelişmiş menü animasyonları, ansiklopedi, ek anlatı. Sonraki kesinti adayları: üçüncü aktif yetenek ve iki kalıntı; bu durumda MVP tablosu ve kabul testleri açıkça revize edilir. Kayıt güvenilirliği, kontrol tepkisi, ölüm okunabilirliği ve erişilebilirlik için temel ayarlar kesilmez.

## 28. Açık kararlar ve doğrulama sırası

Bu maddeler çalışmayı durdurmaz; mevcut varsayımlarla prototip başlayabilir.

1. Gerçek ekip ve haftalık kapasite: üretim başlamadan takvim yeniden hesaplanır.
2. Piksel sanat üretim yöntemi ve karakter oranları: ön üretimde iki kısa görsel denemeyle seçilir.
3. Üç silahın yeterince farklı hissettirmesi: slice sonunda değerlendirilir.
4. Son anda kaçış penceresi: 100 ms başlangıç değeri; cihaz ve oyuncu deneyimine göre test edilir.
5. Sefer uzunluğu: gerçek tamamlanma süreleri üzerinden oda sayısı ayarlanır.
6. 1.0 fiyatı ve dağıtım kanalı: oynanabilir slice ve maliyet görünürlüğünden sonra belirlenir.
7. 1.0 final anlatısı ve alternatif son: MVP'nin dövüş/doğrulama kapısından sonra tasarlanır.

## 29. Başarı tanımı

MVP başarılı sayılırsa oyuncu dış yardıma ihtiyaç duymadan oyuna girer; saldırıları okuyup tepki verir; yemin seçiminin avantajını ve bedelini hisseder; bir seferi tamamlayabilir veya anlaşılır bir hatayla kaybeder; kaydını koruyarak yeniden denemek ister. Bu sonuç sağlanmadan beş bölgelik 1.0 içerik üretimine geçilmez.

## 30. Kaynaklar ve kaynak kullanım sınırı

Bu PRD'deki dünya, mekanikler, sayılar, kapsam ve takvim özgün tasarım önerileridir; kaynaklardan alınmış doğrulanmış ürün metrikleri değildir. Kaynaklar yalnızca referans oyunun türünü ve motorun temel 2D yeteneklerini doğrulamak için kullanılmıştır. Erişim: 5 Eylül 2026.

- [S1] Dead Cells — resmî Steam ürün sayfası: https://store.steampowered.com/app/588650/Dead_Cells/ — roguelite/metroidvania esinli aksiyon platform referansı.
- [S2] Godot Engine — resmî 2D dokümantasyonu: https://docs.godotengine.org/en/stable/tutorials/2d/index.html — 2D renderer, fizik ve ilgili yerleşik araçlar.
