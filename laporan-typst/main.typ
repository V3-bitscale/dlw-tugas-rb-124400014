// Laporan Studi Ablasi ANN, RNN, LSTM, dan GRU
// Sesuaikan identitas anggota, kontribusi, URL repositori, dan periksa angka dengan hasil/ablasi.csv.
#import "@preview/charged-ieee:0.1.4": ieee
#set text(lang: "id")
#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

#show: ieee.with(
  title: [Studi Ablasi RNN, LSTM, dan GRU dibandingkan ANN untuk Prediksi Trafik Seluler Kota Milan],
  abstract: [
    Prediksi trafik seluler membantu operator memperkirakan kebutuhan kapasitas jaringan, tetapi akurasi model dipengaruhi oleh arsitektur dan konfigurasi pelatihan. Studi ini membandingkan Artificial Neural Network (ANN), Recurrent Neural Network (RNN), Long Short-Term Memory (LSTM), dan Gated Recurrent Unit (GRU) menggunakan data trafik seluler Milan. Eksperimen menguji panjang jendela historis, ukuran hidden, jumlah lapisan, learning rate, fitur masukan, dropout, dan fungsi loss. Setiap konfigurasi dijalankan dengan tiga seed, dan performa dinilai menggunakan MAE pada data validasi, pengujian, serta periode Natal. Pada lokasi Duomo, RNN acuan menghasilkan test MAE terendah sebesar 229,6, diikuti GRU sebesar 237,2. GRU menunjukkan perbaikan saat hidden size diperbesar hingga 128, sedangkan dropout 0,5 umumnya menurunkan performa. Pada lokasi Politecnico di Milano, GRU acuan memperoleh test MAE 170,5 dan RNN acuan 171,5. Namun, kesalahan meningkat pada periode Natal, memperlihatkan tantangan ketika pola trafik berubah. Hasil menunjukkan tidak ada satu konfigurasi yang unggul pada seluruh arsitektur, lokasi, dan periode evaluasi.
  ],
  authors: (
    (name: "Vindra Ardi Pratama", department: [NIM 124400014], organization: [Teknik Telekomunikasi, ITERA], email: "vindra.124400014@student.itera.ac.id"),
    (name: "Yerikho Febryan Pane", department: [NIM 124400034], organization: [Teknik Telekomunikasi, ITERA], email: "yerikho.124400034@student.itera.ac.id"),
    (name: "Deo H Maldino Simanjuntak", department: [NIM 124400050], organization: [Teknik Telekomunikasi, ITERA], email: "deo.124400050@student.itera.ac.id"),
  ),
  index-terms: ("prediksi trafik seluler", "ANN", "RNN", "LSTM", "GRU", "studi ablasi"),
  bibliography: bibliography("references.bib", title: [Pustaka]),
  figure-supplement: [Gambar],
)

= Pendahuluan
Prediksi trafik seluler dapat mendukung perencanaan kapasitas dan pengelolaan sumber daya jaringan. Pola trafik berubah menurut waktu dan lokasi sehingga prediksi perlu memanfaatkan informasi historis. ANN menjadi pembanding non-rekuren, sedangkan RNN memproses urutan secara berulang. LSTM dan GRU menggunakan mekanisme gerbang untuk mengatur aliran informasi dan membantu mempelajari ketergantungan temporal yang lebih kompleks.

Studi ablasi mengubah satu faktor pada satu waktu untuk mengamati pengaruhnya terhadap performa. Kontribusi studi ini adalah: (1) membandingkan ANN, RNN, LSTM, dan GRU pada beberapa konfigurasi; (2) mengevaluasi pengaruh parameter model, fitur, dropout, dan fungsi loss; serta (3) menguji apakah hasil pada lokasi Duomo tetap berlaku pada lokasi Politecnico di Milano.

= Data dan Metode

== Dataset
Data berasal dari dataset trafik seluler Telecom Italia di Milan. Eksperimen utama menggunakan lokasi Duomo (kotak 5060), sedangkan generalisasi menggunakan lokasi kelompok berkode 4, yaitu Politecnico di Milano (kotak 5772). Target yang diprediksi adalah trafik internet (`net`). Fitur masukan diuji dalam beberapa kombinasi: `net`; `net+call+sms`; `net+waktu`; dan seluruh fitur yang tersedia.

== Pembagian Data dan Praproses
Pembagian dilakukan secara kronologis untuk menjaga urutan waktu: data latih 11 November–8 Desember 2013, validasi 9–15 Desember, pengujian 16–22 Desember, dan evaluasi tambahan periode Natal mulai 23 Desember. Data 4–10 November dapat digunakan sebagai konteks historis untuk pembentukan jendela. Pembagian kronologis sesuai dengan skenario prediksi nyata dan menghindari kebocoran informasi masa depan. Prediksi menggunakan jendela historis dengan horizon satu langkah pada konfigurasi acuan.

== Model dan Konfigurasi Acuan
ANN memetakan fitur masukan ke prediksi tanpa pemrosesan rekuren eksplisit. RNN membawa keadaan tersembunyi antar-langkah waktu. LSTM menggunakan gerbang masukan, lupa, dan keluaran, sedangkan GRU memakai gerbang pembaruan dan reset dengan struktur yang lebih ringkas.

#figure(
  caption: [Konfigurasi acuan], placement: top,
  table(columns: 2, align: left, stroke: none,
    table.hline(), table.header([*Hyperparameter*], [*Nilai acuan*]), table.hline(stroke: 0.5pt),
    [Panjang jendela $W$], [24 jam], [Horizon], [1 jam],
    [Hidden size], [ANN 32; RNN 68; LSTM 33; GRU 38],
    [Jumlah lapisan], [ANN 2; model rekuren 1],
    [Fitur], [Semua fitur (7)], [Optimizer dan learning rate], [Adam; $10^(-3)$],
    [Batch size], [64], [Early stopping], [Patience 30; maksimum 300 epoch], table.hline(),
  ),
) <tab:acuan>

== Protokol Ablasi dan Evaluasi
Bagian A menguji (A1) window size 6, 12, 24, 48, dan 168; (A2) hidden size 16, 32, 64, dan 128; (A3) satu, dua, dan tiga lapisan; (A4) learning rate 0,0001, 0,001, dan 0,01; serta (A5) empat kombinasi fitur. Bagian B menguji dropout 0, 0,2, dan 0,5 serta fungsi loss MSE, MAE, dan Huber. Setiap konfigurasi menggunakan tiga seed (0, 1, 2). Pelaporan menggunakan rata-rata dan simpangan baku jika tersedia. MAE menyatakan rata-rata kesalahan absolut dan nilai lebih rendah lebih baik; RMSE lebih sensitif terhadap kesalahan besar, sedangkan MAPE perlu ditafsirkan hati-hati jika target nol atau mendekati nol. Pelatihan dijalankan pada CPU dengan `CEPAT = False`; total waktu training tercatat sekitar 108,4 menit berdasarkan ringkasan hasil.

= Hasil

== Baseline Naif dan Acuan
Pada lokasi Duomo, baseline naif untuk horizon satu langkah menghasilkan MAE validasi/pengujian/Natal berturut-turut: nilai terakhir 662,6/600,9/431,2; nilai hari sebelumnya 595,3/552,2/921,5; dan nilai minggu sebelumnya 492,8/467,6/1426,2. Pada horizon 24 langkah, MAE pengujian untuk nilai terakhir, hari sebelumnya, dan minggu sebelumnya adalah 2769,3; 563,4; dan 466,1. Baseline naif menunjukkan bahwa strategi sederhana dapat kompetitif pada kondisi tertentu, tetapi performanya berubah drastis pada periode Natal.

#figure(caption: [Hasil model acuan pada lokasi Duomo (rata-rata tiga seed).], placement: top,
  table(columns: 4, align: (left, center, center, center), stroke: none,
    table.hline(), table.header([*Model*], [*Val MAE*], [*Test MAE*], [*Natal MAE*]), table.hline(stroke: 0.5pt),
    [ANN], [248,9 ± 8,9], [309,9 ± 5,9], [680,1 ± 52,0],
    [RNN], [206,1 ± 7,4], [229,6 ± 5,1], [421,2 ± 2,4],
    [LSTM], [230,5 ± 12,2], [273,6 ± 25,4], [586,0 ± 56,8],
    [GRU], [207,5 ± 3,8], [237,2 ± 9,3], [468,2 ± 21,8], table.hline(),
  ),
) <tab:baseline>

RNN merupakan model acuan terbaik pada lokasi Duomo berdasarkan ketiga periode yang dilaporkan. Test MAE RNN sebesar 229,6 lebih rendah daripada GRU (237,2), LSTM (273,6), dan ANN (309,9). GRU mendekati RNN pada validasi. Hasil ini menunjukkan bahwa kompleksitas arsitektur yang lebih tinggi tidak otomatis meningkatkan akurasi.

== Ablasi Wajib

=== A1: Window size
RNN menghasilkan hasil terbaik pada $W=48$, dengan validation MAE 200,1 dan test MAE 224,5. Ketika window ANN diperbesar dari 6 menjadi 168, test MAE meningkat dari 269,4 menjadi 402,0. Panjang jendela yang lebih besar tidak selalu membantu: informasi tambahan dapat menambah kesulitan pembelajaran, terutama pada ANN yang mengolah jendela sebagai masukan fitur. GRU relatif stabil untuk $W$ 24–168, sementara LSTM tidak menunjukkan peningkatan monoton.

=== A2: Hidden size
GRU menunjukkan peningkatan paling konsisten ketika hidden size diperbesar. Pada hidden size 16, GRU memperoleh test MAE 246,9, sedangkan pada ukuran 128 nilainya menjadi 220,3; validation MAE pada ukuran 128 adalah 188,7. LSTM juga membaik dari test MAE 295,3 pada ukuran 16 menjadi 245,6 pada ukuran 128. Namun, ANN tidak monoton: test MAE pada ukuran 64 (316,2) lebih tinggi daripada ukuran 32 (309,9). Hidden size yang sama juga tidak menyamakan jumlah parameter antararsitektur.

=== A3: Jumlah lapisan
Penambahan lapisan tidak selalu memperbaiki hasil. RNN satu dan dua lapisan memperoleh test MAE 229,6 dan 228,4, tetapi tiga lapisan meningkatkan MAE menjadi 245,5. Pada GRU, dua lapisan memberi validasi terbaik (203,3), tetapi test MAE 239,2 sedikit lebih buruk daripada satu lapisan (237,2). Dampak paling besar terlihat pada LSTM: test MAE meningkat dari 273,6 pada satu lapisan menjadi 412,6 pada tiga lapisan. Hasil ini konsisten dengan kemungkinan bahwa model yang lebih dalam lebih sulit dioptimalkan pada data yang tersedia; pemeriksaan kurva loss tetap diperlukan sebelum menyimpulkan overfitting.

=== A4: Learning rate
Pada learning rate 0,0001, semua model mencapai batas 300 epoch dan memperoleh MAE yang relatif tinggi. Hal ini mengindikasikan bahwa pembaruan parameter mungkin terlalu kecil untuk konfigurasi ini. Pada learning rate 0,01, LSTM dan GRU masing-masing memperoleh test MAE 225,8 dan 215,7, lebih baik daripada konfigurasi acuan mereka (273,6 dan 237,2). Sebaliknya, test MAE RNN naik dari 229,6 menjadi 245,8. Karena itu, learning rate yang sesuai bergantung pada arsitektur. Jumlah epoch untuk learning rate 0,01 perlu diambil langsung dari CSV sebelum laporan final.

=== A5: Fitur masukan
Fitur masukan berpengaruh berbeda pada setiap model. RNN menghasilkan hasil terbaik dengan seluruh fitur, yaitu validation MAE 206,1 dan test MAE 229,6. GRU memperoleh validation MAE terbaik dengan `net+waktu` (213,2), sedangkan test MAE terbaiknya diperoleh dengan seluruh fitur (237,2). Untuk LSTM, test MAE terendah adalah 262,7 dengan `net+call+sms`; ANN justru memiliki test MAE terendah dengan `net` saja (271,8). Jadi, penambahan fitur tidak selalu memperbaiki semua model, meskipun fitur tambahan dapat membantu menangkap hubungan temporal dan aktivitas komunikasi.

== Ablasi Pilihan

=== B2: Dropout
Dropout 0,2 menurunkan test MAE GRU dari 237,2 menjadi 225,0 dan LSTM dari 273,6 menjadi 264,6. Namun, ANN dan RNN memburuk pada nilai yang sama. Pada dropout 0,5, test MAE seluruh model meningkat dibandingkan baseline; ANN mencapai 411,6. Hal ini menunjukkan bahwa regularisasi ringan dapat membantu model tertentu, tetapi dropout yang terlalu besar dapat membatasi kemampuan model mempelajari pola dari data.

=== B4: Fungsi loss
Loss MAE menghasilkan test MAE 299,3 pada ANN dan 220,6 pada GRU, lebih rendah daripada konfigurasi MSE masing-masing. Huber memberikan test MAE 225,3 pada RNN dan 271,6 pada LSTM. Dengan demikian, fungsi loss terbaik bergantung pada model. Nilai RNN dengan loss MAE yang tercatat sebagai test MAE 207,1 perlu diverifikasi kembali pada `hasil/ablasi.csv`, karena ringkasan tersebut berbeda cukup jauh dari baseline dan lebih rendah daripada validation MAE.

== Konfigurasi Terbaik
Pada lokasi Duomo, konfigurasi terbaik memperbaiki ANN: test MAE turun dari 309,9 menjadi 276,2 dan Natal MAE dari 680,1 menjadi 597,3. LSTM juga membaik, dengan test MAE turun dari 273,6 menjadi 244,2 dan Natal MAE dari 586,0 menjadi 498,4. Sebaliknya, GRU sedikit memburuk pada test MAE (237,2 menjadi 237,6) dan Natal MAE (468,2 menjadi 512,8). RNN juga memburuk dari test MAE 229,6 menjadi 247,7. Oleh karena itu, memilih nilai terbaik dari eksperimen satu faktor secara terpisah tidak menjamin kombinasi akhirnya menjadi terbaik.

== Uji Generalisasi

#figure(caption: [Perbandingan model acuan dan konfigurasi terbaik pada lokasi Politecnico di Milano.], placement: top,
  table(columns: 4, align: (left, center, center, center), stroke: none,
    table.hline(), table.header([*Model*], [*Konfigurasi*], [*Test MAE*], [*Natal MAE*]), table.hline(stroke: 0.5pt),
    [ANN], [Acuan], [222,1 ± 38,2], [1144,6 ± 190,8], [ANN], [Terbaik], [179,2 ± 22,1], [854,6 ± 102,2],
    [GRU], [Acuan], [170,5 ± 7,8], [880,7 ± 130,6], [GRU], [Terbaik], [202,2 ± 13,8], [951,8 ± 35,8],
    [LSTM], [Acuan], [239,5 ± 61,9], [939,8 ± 205,6], [LSTM], [Terbaik], [191,4 ± 21,7], [811,2 ± 57,3],
    [RNN], [Acuan], [171,5 ± 13,1], [713,3 ± 38,8], [RNN], [Terbaik], [194,3 ± 23,8], [722,2 ± 112,3], table.hline(),
  ),
) <tab:generalisasi>

#figure(
  image("peta_lokasi_tugas.png", width: 100%),
  caption: [Peta lokasi tugas dan lokasi Duomo pada dataset trafik jaringan seluler Milan.],
) <fig:peta-lokasi>

Pada lokasi Politecnico di Milano, GRU acuan memperoleh test MAE terendah (170,5), diikuti RNN acuan (171,5). RNN acuan mempunyai validation MAE terendah (145,1) dan Natal MAE terendah di antara model terlatih (713,3). Konfigurasi terbaik membantu ANN dan LSTM pada test MAE, tetapi memperburuk hasil GRU dan RNN. Urutan performa karenanya berubah menurut lokasi dan konfigurasi.

Pada periode Natal, MAE model meningkat tajam. Baseline naif nilai terakhir di lokasi ini memperoleh Natal MAE 57,2, jauh lebih rendah daripada model terlatih. Sebaliknya, metode minggu sebelumnya memiliki Natal MAE 1846,8. Perbedaan tersebut menegaskan bahwa perubahan pola trafik dapat membuat metode yang baik pada periode reguler tidak sesuai untuk periode khusus. Dugaan bahwa perubahan ini terkait aktivitas liburan perlu dipandang sebagai interpretasi, bukan sebab yang telah dibuktikan.

= Pembahasan
Hasil menunjukkan bahwa RNN dan GRU merupakan kandidat kuat, tetapi tidak ada arsitektur yang terbaik pada semua kondisi. RNN unggul pada baseline Duomo, sementara GRU memiliki test MAE acuan terendah pada Politecnico. GRU juga memperoleh manfaat dari hidden size yang lebih besar. Sebaliknya, penambahan lapisan khususnya pada LSTM dan dropout tinggi cenderung menurunkan performa. Hal ini menggarisbawahi pentingnya menyesuaikan kapasitas dan regularisasi model terhadap jumlah serta karakteristik data.

Pengaruh fitur dan learning rate juga bergantung pada arsitektur. Seluruh fitur membantu RNN, tetapi ANN mendapat test MAE terendah dengan `net` saja. Learning rate 0,01 membantu LSTM dan GRU dalam hasil yang tercatat, namun tidak membantu RNN. Karena hasil dilaporkan dari tiga seed, simpangan baku dapat memberi gambaran variasi antar-run; perbedaan kecil perlu ditafsirkan hati-hati dan bukan dianggap pasti signifikan tanpa uji statistik.

Keterbatasan studi meliputi penggunaan data dari satu kota, periode pelatihan yang relatif singkat, satu pembagian kronologis, serta perubahan pola yang besar pada periode Natal. Selain itu, pemilihan konfigurasi berdasarkan validasi tidak menjamin hasil terbaik pada test atau lokasi baru. Karena itu, evaluasi lebih banyak lokasi dan periode serta pemeriksaan variasi antar-seed dapat memperkuat kesimpulan.

= Kesimpulan
Pada lokasi Duomo, RNN acuan memperoleh test MAE terbaik sebesar 229,6, sedangkan pada Politecnico di Milano GRU acuan memperoleh test MAE terendah sebesar 170,5. Ablasi memperlihatkan bahwa pengaruh window size, hidden size, jumlah lapisan, learning rate, fitur, dropout, dan fungsi loss bergantung pada arsitektur; penambahan kompleksitas tidak otomatis meningkatkan akurasi. Konfigurasi terbaik memperbaiki ANN dan LSTM pada beberapa evaluasi, tetapi tidak memperbaiki RNN dan GRU secara konsisten. Performa pada periode Natal menurun tajam, sehingga evaluasi lintas periode dan lokasi penting sebelum model digunakan untuk perencanaan trafik nyata.

#heading(numbering: none)[Kontribusi Anggota]
#table(columns: (auto, 1fr), stroke: none,
  [Vindra Ardi Pratama], [Eksperimen A1 sampai A3 dan penyusunan laporan.],
  [Yerikho Febryan Pane], [Eksperimen A4 sampai A5 dan A serta analisis hasil.],
  [Deo H Maldino Simanjuntak], [Eksperimen B–D dan penyuntingan laporan.],
)

#heading(numbering: none)[Pernyataan Penggunaan AI]
ChatGPT digunakan untuk membantu menyusun struktur laporan dan merapikan penjelasan hasil eksperimen.

#heading(numbering: none)[Kode dan Data]
Kode, notebook beserta output, dan seluruh hasil run tersedia di #link("https://github.com/username/nama-repo"). Ganti tautan tersebut dengan URL repositori kelompok yang sebenarnya.
