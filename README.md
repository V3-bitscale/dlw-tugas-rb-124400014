# Studi Ablasi RNN, LSTM, GRU vs ANN untuk Prediksi Trafik Seluler Milan

Tugas Workshop Deep Learning — Teknik Telekomunikasi ITERA.

## Kelompok

| Peran | Nama | NIM |
|---|---|---|
| Ketua | Vindra Ardi Pratama | 124400014 |
| Anggota | Nama Anggota | NIM |
| Anggota | Nama Anggota | NIM |

- **Kelas:** RB
- **Lokasi kelompok:** 4 — Politecnico di Milano
- **Laporan:** https://typst.app/project/pRAgHYgHInSu7ZJiN35QeE

## Cara Menjalankan

```bash
uv sync
uv run jupyter lab
```

Buka `tugas_ablasi.ipynb`, isi `LOKASI_KELOMPOK`, lalu jalankan semua sel. Semua run tercatat di `hasil/ablasi.csv`.

Perangkat yang kami pakai: [contoh: laptop CPU Intel i5 / Google Colab T4], total waktu training: [x] menit.

## Ringkasan Hasil

[2–4 kalimat temuan utama, beserta angka test MAE terbaik per model.]

## Struktur

```
tugas_ablasi.ipynb      notebook eksperimen (di-commit beserta output)
data/                   data trafik per jam (Duomo + 10 lokasi tugas)
hasil/                  CSV seluruh run, tabel, dan grafik
laporan-latex/ atau laporan-typst/   sumber laporan + PDF
```

## Data

Telecom Italia Big Data Challenge (Barlacchi dkk., 2015, *Scientific Data*, lisensi ODbL), versi per jam dari Zhang dkk. (INFOCOM 2021). Disiapkan oleh pengajar di repo [mctosima/dl-workshop](https://github.com/mctosima/dl-workshop).
