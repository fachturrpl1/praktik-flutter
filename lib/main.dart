import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 2
  );

class Barang {
  final String namaBarang;
  final double hargaMember;
  final double hargaUmum;
  final String kategori;
  int _stock;
  double potongan = 0;

  Barang({
    required this.namaBarang,
    required this.hargaMember,
    required this.hargaUmum,
    required int stock,
    required this.kategori,
  }) : _stock = stock;

  //getter
  int get stock => _stock;
  
  bool bisaDijual(int diminta) {
    return _stock >= diminta;
  }

  bool jual(int n) {
    if (bisaDijual(n)) {
      _stock -= n;
      print("Berhasil menjual $n pcs $namaBarang. Sisa stok: $_stock");
      return true;
    } else {
      print("Gagal menjual $namaBarang! Stok tidak mencukupi (Tersedia: $_stock, Diminta: $n)");
      return false;
    }
  }

  bool cekTersedia() {
    if (stock > 0) {
      return true;
    } else {
      return false;
    }
  }

  // Mengapa melindungi _stok penting bagi integritas data koperasi?
  // 1. Mencegah Modifikasi diluar class
  // 2. Konsistensi Perubahan stok wajib melalui transaksi resmi (method jual()), 
  //    sehingga riwayat pencatatan barang masuk/keluar di sistem koperasi selalu sinkron dengan stok fisik.
  // 3. Serta pada method cekTersedia berfungsi untuk menghindari Stok Negatif


  void tampilkanKartuBarang(){
    print("\n=== KARTU DATA BARANG ===");
    print("nama barang: ${namaBarang}");
    print("harga anggota: ${formatRupiah.format(hargaMember)}");
    print("harga umum: ${formatRupiah.format(hargaUmum)}");
    print("jumlah stok: ${_stock}");
    print("tersedia: ${statusBarang(cekTersedia())}");
    print('Lokasi berada di: ${lokasiRak(kategori)}');
  }
}

class BarangPromo extends Barang {
  double diskonPromo;

  BarangPromo({
    required super.namaBarang,
    required super.hargaMember,
    required super.hargaUmum,
    required super.stock,
    required super.kategori,
    required this.diskonPromo,
  });

  double hitungHargaPromo(bool isMember){
    double harga = isMember ? hargaMember : hargaUmum;
    return harga - (harga * diskonPromo);
  }
}

class Pembeli {
  final String nama;
  bool statusAnggota;

  Pembeli({
    required this.nama,
    required this.statusAnggota,
  });

  bool cekStatus(statusAnggota){
    if (statusAnggota) {
      return true;
    } else {
      return false;
    }
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

void daftarBarangBernomor(List<Barang> daftarBarang) {
  print("\n=== DAFTAR BARANG ===");
  for (int i = 0; i < daftarBarang.length; i++){
    String nomor = "${i + 1}. ";
    String barang = "${daftarBarang[i].namaBarang}";
    String harga = "${formatRupiah.format(daftarBarang[i].hargaUmum)}";
    print("${nomor}${barang} - ${harga}");
  }
}

double hitungHarga(bool anggota, double hAnggota, double hUmum) {
  return anggota ? hAnggota : hUmum;
}
double nilaiStok(double harga, int jumlah) {
  return harga * jumlah;
}
double hitungNominalPotongan(double total, double persenPotongan) {
  return (total * persenPotongan / 100);
}
double hitungHargaAkhir(double total, double persenPotongan) {
  return total - hitungNominalPotongan(total, persenPotongan);
}
double bayarAkhir(int jumlah, double hargaSatuan, double persenPotongan){
  double totalAwal = nilaiStok(hargaSatuan, jumlah);
  return hitungHargaAkhir(totalAwal, persenPotongan);
}

void transaksi(Barang barang, bool member, int jumlah) {
  double hargaSatuan = hitungHarga(member, barang.hargaMember, barang.hargaUmum);
  double totalAwal = nilaiStok(hargaSatuan, jumlah);

  if (totalAwal <= 0) {
    print("\n=== TRANSAKSI ===");
    print("Total harga tidak valid. Transaksi dibatalkan.");
    return;
  }

  double harga = 0;
  if (member) {
    harga = barang.hargaMember;
  } else {
    harga = barang.hargaUmum;
  }

  double persenPotongan = 0;
  if (member && (harga > 500000)){
    persenPotongan = 0.15;
  } else if (harga > 200000) {
    persenPotongan = 0.1;
  } else if (harga > 100000) {
    persenPotongan = 0.05;
  }

  double nominalPotongan = hitungNominalPotongan(totalAwal, persenPotongan);
  double hargaAkhir = bayarAkhir(jumlah, hargaSatuan, persenPotongan);

  print("\n=== TRANSAKSI ===");
  print('Member            : ${member ? "Ya" : "Tidak"}');
  print('Nama barang       : ${barang.namaBarang}');
  print('Harga barang      : ${formatRupiah.format(hargaSatuan)}');
  print('Jumlah beli       : $jumlah');
  print('Total belanja awal: ${formatRupiah.format(totalAwal)}');
  print('Potongan          : $persenPotongan%');
  print('Nominal potongan  : ${formatRupiah.format(nominalPotongan)}');
  print('=' * 28);
  print('Total harga akhir : ${formatRupiah.format(hargaAkhir)}');
}

void stockPenjualan(Barang barang, int stock){
  print("\n--- Penjualan ${barang.namaBarang} ---");
  while (barang._stock > 0) { //jika operator '> 0' dihapus, akan menyebabkan infinite loop
    barang._stock--; //jika line ini dihapus, akan menyebabkan infinite loop
    print("Terjual 1, sisa stok: ${barang._stock}");
  }
  // 1. Jika kondisi berhenti pada 'while' keliru:
  // - Program dapat mengalami 'infinite loop'
  // - Menimbulkan laporan keuangan/stok tidak valid.

  // 2. Cara memastikan koperasi tidak menjual melebihi stok:
  // - Menggunakan validasi kondisi sebelum transaksi: 'if (jumlah <= barang.stock)'.
  // - Jika stok mencukupi, kurangi stok ('barang.stock -= jumlah') dan lanjutkan transaksi.
  // - Jika stok kurang, batalkan transaksi dan tampilkan pesan peringatan bahwa stok tidak mencukupi.
  // - Menjaga kondisi perulangan dengan 'while (barang.stock > 0)' agar perulangan otomatis berhenti tepat saat stok bernilai 0.

}

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
  for (var barang in daftarBarang) {
    if (barang._stock < 5) {
      print("${barang.namaBarang}: sisa ${barang._stock} pcs (Kategori: ${barang.kategori})");
    }
  }
}

void main() {
  //daftar barang
  Barang barang1 = Barang(
    namaBarang: "Buku Tulis",
    hargaMember: 3000.0,
    hargaUmum: 3500.0,
    stock: 3,
    kategori: "atk",
  );

  Barang barang2 = Barang(
    namaBarang: "Pulpen",
    hargaMember: 2500.0,
    hargaUmum: 3000.0,
    stock: 10,
    kategori: "atk"
  );

  Barang barang3= Barang(
    namaBarang: "Roti",
    hargaMember: 2000.0,
    hargaUmum: 2500.0,
    stock: 2,
    kategori: "makanan",
  );

  BarangPromo barang4 = BarangPromo(
    namaBarang: "Roti lapis",
    hargaMember: 5000.0,
    hargaUmum: 6000.0,
    stock: 10,
    kategori: "makanan",
    diskonPromo: 0.2,
  );

  List<Barang> koperasi = [barang1, barang2, barang3];

//memanggil fungsi
  // daftarBarangBernomor(koperasi);

  // print("===| DAFTAR BARANG KOPERASI |===");
  // for (var barang in koperasi) {
  //   barang.tampilkanKartuBarang();
  // }
  
  barang1.jual(2);

  double promoMember = barang4.hitungHargaPromo(false);
  print("\nHarga Umum (Promo) : ${formatRupiah.format(promoMember)}");

  double promoUmum = barang4.hitungHargaPromo(true);
  print("\nHarga member (Promo) : ${formatRupiah.format(promoUmum)}");
  
/*
   1. Data & method dibungkus dalam class 'Barang', bukan diluarnya
   2. Tambah barang cukup buat object baru & masuk List<Barang>;
      looping otomatis mencetak semua tanpa tambah kode cetak
   3. Kode lebih bersih, rapi, terstruktur
*/

/* 
  Apa Keuntungan memodelkan barang sebagai objek bagi pengembangan sistem koperasi kedepan?
   1. Mudah menambah fitur baru, seperti stok otomatis berkurang, diskon khusus, atau tanggal kadaluarsa 
      cukup dengan mengedit 'class Barang' tanpa merusak kode utama.
   
   2. Kode Dapat Digunakan Kembali seperti Objek 'Barang' bisa dipakai 
      di berbagai modul sistem koperasi sekaligus, mulai dari kasir, laporan 
      stok gudang, hingga aplikasi mobile anggota.
   
   3. Kemudahan Integrasi Database, Struktur berbasis objek selaras 
      dengan format data seperti JSON/API sehingga 
      sistem siap dihubungkan ke backend/server
*/

  // transaksi(barang1, true, 2);
  // transaksi(barang1, false, 1, 150000);
  // transaksi(barang1, false, 1, 50000);

  // stockPenjualan(barang1, 3);
  // print("\n========= KOPERASI ========");
  // print("==== TOTAL STOK BARANG ====");
  // print("nama | stok | harga | total ");
  // totalStock(koperasi, "Buku Tulis", 3);
  // totalStock(koperasi, "Pulpen", 10);
  // totalStock(koperasi, "Blupen", 5);

  // lowStock(koperasi);

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
