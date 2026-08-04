import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 2
  );

class Barang {
  final String namaBarang;
  final num hargaMember;
  final num hargaUmum;
  final String kategori;
  bool get tersedia => stock > 0;
  int stock;
  num potongan = 0;
Barang({
  required this.namaBarang,
  required this.hargaMember,
  required this.hargaUmum,
  required this.stock,
  required this.kategori,
});
}

String lokasiRak(String kategori) {
  switch (kategori) {
    case "atk":
      return "Rak 1";
    case "makanan":
      return "Rak 2";
    case "minuman":
      return "Rak 3";
    default:
      return "Rak lain";
  }
}

String statusBarang(bool tersedia) {
  switch (tersedia) {
    case true:
      return "iya";
    case false:
      return "tidak";
  }
}

void daftarBarangBernomor(List<Barang> daftarBarang) {
  print("\n=== DAFTAR BARANG ===");
  for (int i = 0; i < daftarBarang.length; i++){
    String nomor = "${i + 1}. ";
    String barang = "${daftarBarang[i].namaBarang}";
    String harga = "${formatRupiah.format(daftarBarang[i].hargaUmum)}";
    print("${nomor}${barang} - ${harga}");
  }
}

void tampilkanKartuBarang(Barang barang1){
  print("\n=== KARTU DATA BARANG ===");
  print("nama barang: ${barang1.namaBarang}");
  print("harga anggota: ${formatRupiah.format(barang1.hargaMember)}");
  print("harga umum: ${formatRupiah.format(barang1.hargaUmum)}");
  print("jumlah stok: ${barang1.stock}");
  print("tersedia: ${statusBarang(barang1.tersedia)}");
  print('Lokasi berada di: ${lokasiRak(barang1.kategori)}');
}

void transaksi(Barang barang1, bool member, int jumlah, num totalHarga){
  totalHarga = jumlah * (member ? barang1.hargaMember : barang1.hargaUmum);

  if (totalHarga <= 0) {
    print("\n=== TRANSAKSI ===");
    print("Total harga tidak valid. Transaksi dibatalkan.");
    return;
  }

  num harga = 0;
  if (member) {
    harga = barang1.hargaMember;
  } else {
    harga = barang1.hargaUmum;
  }

  double potongan = 0;
  if (member && (totalHarga > 500000)){
    potongan = 0.15;
  } else if (totalHarga > 200000) {
    potongan = 0.1;
  } else if (totalHarga > 100000) {
    potongan = 0.05;
  }

  barang1.stock -= jumlah;

  num hargaAkhir = totalHarga - (totalHarga * potongan);

  print("\n=== TRANSAKSI ===");
  print('Member: ${member ? "Ya" : "Tidak"}');
  print('Nama barang: ${barang1.namaBarang}');
  print('Harga barang: ${formatRupiah.format(harga)}');
  print('Jumlah beli: $jumlah');
  print('Potongan: ${potongan*100}%');
  print('Total potongan: ${formatRupiah.format(totalHarga * potongan)}');
  print('Total belanja awal: ${formatRupiah.format(totalHarga)}');
  print('='*18);
  print('Total harga akhir: ${formatRupiah.format(hargaAkhir)}');

}

void stockPenjualan(Barang barang, int stock){
  print("\n--- Penjualan ${barang.namaBarang} ---");
  while (barang.stock > 0) { //jika operator '> 0' dihapus, akan menyebabkan infinite loop
    barang.stock--; //jika line ini dihapus, akan menyebabkan infinite loop
    print("Terjual 1, sisa stok: ${barang.stock}");
  }
}
// 1. Jika kondisi berhenti pada 'while' keliru:
// - Program dapat mengalami 'infinite loop'
// - Menimbulkan laporan keuangan/stok tidak valid.

// 2. Cara memastikan koperasi tidak menjual melebihi stok:
// - Menggunakan validasi kondisi sebelum transaksi: 'if (jumlah <= barang.stock)'.
// - Jika stok mencukupi, kurangi stok ('barang.stock -= jumlah') dan lanjutkan transaksi.
// - Jika stok kurang, batalkan transaksi dan tampilkan pesan peringatan bahwa stok tidak mencukupi.
// - Menjaga kondisi perulangan dengan 'while (barang.stock > 0)' agar perulangan otomatis berhenti tepat saat stok bernilai 0.

//data dari list 
void totalStock(List<Barang> daftarBarang, String namaBarang, int stock) {
  int index = daftarBarang.indexWhere(
    (b) => b.namaBarang.toLowerCase() == namaBarang.toLowerCase(),
  );

  if (index != -1) {
    Barang barangTerpilih = daftarBarang[index];
    num hargaBarang = barangTerpilih.hargaUmum;
    num total = stock * hargaBarang;
    print(
      "${barangTerpilih.namaBarang}: $stock x ${formatRupiah.format(hargaBarang)} = ${formatRupiah.format(total)}",
    );
  } else {
    print("Barang '$namaBarang' tidak ditemukan!");
  }
}

void lowStock(List<Barang> daftarBarang) {
  print("\n==== STOK MENIPIS ====");
  bool lowOnStock = false;
  for (var barang in daftarBarang) {
    if (barang.stock < 5) {
      print("${barang.namaBarang}: sisa ${barang.stock} pcs (Kategori: ${barang.kategori})");
      lowOnStock = true;
    }
  }
}

void main() {
  
  Barang barang1 = Barang(
    namaBarang: "Buku Tulis",
    hargaMember: 3000.0,
    hargaUmum: 3500.0,
    stock: 3,
    kategori: "atk",
  );

  Barang barang2 = Barang(
    namaBarang: "Roti",
    hargaMember: 2000.0,
    hargaUmum: 2500.0,
    stock: 2,
    kategori: "makanan",
  );

  List<Barang> koperasi = [barang1, barang2];

  daftarBarangBernomor(koperasi);
  // tampilkanKartuBarang(barang1);
  // tampilkanKartuBarang(barang2);

  // transaksi(barang1, true, 1, 700000);
  // transaksi(barang1, false, 1, 150000);
  // transaksi(barang1, false, 1, 50000);

  // stockPenjualan(barang1, 3);
  print("\n========= KOPERASI ========");
  print("==== TOTAL STOK BARANG ====");
  print("nama | stok | harga | total ");
  totalStock(koperasi, "Buku Tulis", 3);
  totalStock(koperasi, "Pulpen", 10);
  totalStock(koperasi, "Blupen", 5);

  lowStock(koperasi);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Flutter Saya',// <------------- JUDUL APLIKASI
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepOrange).primaryContainer
      ),
      home: const MyHomePage(title: 'Ini adalah Header'),// <------------- JUDUL HEADER
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
