import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 2
  );

class Barang {
  String namaBarang;
  double hargaUmum;
  double hargaMember;
  String kategori;
  int _stock;
  
  Barang({
    required this.namaBarang,
    required this.hargaUmum,
    required this.hargaMember,
    required this.kategori,
    required int stock,
  }) : _stock = stock;

  int get stock => _stock;

  bool bisaDijual(int diminta) {
    return _stock >= diminta;
  }

  //method untuk mengurangi stok barang
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

  //method untuk menambah stok barang
  void tambahStok(int n) {
    if (n <= 0) {
      print("Jumlah restock tidak valid, diabaikan.");
      return;
    }
    _stock += n;
    print("Restock $namaBarang sebanyak $n. Stok sekarang: $_stock");
  }

  bool cekTersedia() {
    if (stock > 0) {
      return true;
    } else {
      return false;
    }
    /*
    Mengapa melindungi _stok penting bagi integritas data koperasi?
    1. Mencegah Modifikasi diluar class
    2. Konsistensi Perubahan stok wajib melalui transaksi resmi (method jual()), 
      sehingga riwayat pencatatan barang masuk/keluar di sistem koperasi selalu sinkron dengan stok fisik.
    3. Serta pada method cekTersedia berfungsi untuk menghindari Stok Negatif
    */
  }

  void tampilkanKartuBarang(){
    print("\n=== KARTU DATA BARANG ===");
    print("nama barang: ${namaBarang}");
    print("harga anggota: ${formatRupiah.format(hargaMember)}");
    print("harga umum: ${formatRupiah.format(hargaUmum)}");
    print("jumlah stok: ${stock}");
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

  @override
  void tampilkanKartuBarang(){
    print("\n=== KARTU DATA BARANG [PROMO] ===");
    print("nama barang: ${namaBarang}");
    print("harga anggota: dari ${formatRupiah.format(hargaMember)} ke ${formatRupiah.format(hitungHargaPromo(true))}🔥");
    print("harga umum: dari ${formatRupiah.format(hargaUmum)} ke ${formatRupiah.format(hitungHargaPromo(false))}");
    print("jumlah stok: ${stock}");
    print("Diskon Promo: ${diskonPromo * 100}%");
    print("tersedia: ${statusBarang(cekTersedia())}");
    print('Lokasi berada di: ${lokasiRak(kategori)}');
  }
}

class BarangGrosir extends Barang {
  int minBeli;
  double potonganGrosir;

  BarangGrosir({
    required super.namaBarang,
    required super.hargaMember,
    required super.hargaUmum,
    required super.stock,
    required super.kategori,
    required this.minBeli,
    required this.potonganGrosir,
  });

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

double pilihHargaKeanggotaan(bool anggota, double hAnggota, double hUmum) {
  return anggota ? hAnggota : hUmum;
}
double totalBeli(double harga, int jumlah) {
  return harga * jumlah;
}
double hitungNominalPotongan(double total, double persenPotongan) {
  return (total * persenPotongan / 100);
}
double hitungHargaAkhir(double total, double persenPotongan) {
  return total - hitungNominalPotongan(total, persenPotongan);
}
double bayarAkhir(int jumlah, double hargaSatuan, double persenPotongan){
  double totalAwal = totalBeli(hargaSatuan, jumlah);
  return hitungHargaAkhir(totalAwal, persenPotongan);
}
int? prosesBeliHelper(String input) {
  try {
    return int.parse(input);
  } catch (e) {
    print('\n=== TRANSAKSI ===');
    print("'$input' bukan berupa angka valid, masukkan angka!");
    print('='*17);
    return null;
  }
}

//menampilkan daftar barang bernomor
void daftarBarangBernomor(List<Barang> daftarBarang) {
  print("\n=== DAFTAR BARANG ===");
  for (int i = 0; i < daftarBarang.length; i++) {
    String nomor = "${i + 1}. ";
    String nama = daftarBarang[i].namaBarang;
    String harga = formatRupiah.format(daftarBarang[i].hargaUmum);
    print("$nomor$nama - $harga");
  }
}

//proses inti
void transaksi(Barang barang, bool member, String inputJumlah) {
  try {
    //validasi angka
    int? jumlah = prosesBeliHelper(inputJumlah);
    if (jumlah == null) return;

    //validasi jumlah beli
    if (jumlah <= 0) {
      print("Jumlah beli harus lebih dari 0!");
      print("Transaksi dibatalkan");
      return;
    }

    //menentukan harga berdasarkan keanggotaan
    double hargaSatuan = pilihHargaKeanggotaan(member, barang.hargaMember, barang.hargaUmum);
    double totalAwal= totalBeli(hargaSatuan, jumlah);

    //cek jika total harga bernilai negatif
    if (totalAwal <= 0) {
      print("\nTotal harga tidak valid, Transaksi dibatalkan");
      return;
    }

    //mengecek stock sebelum mengurangi stok, prevent stock menjadi negatif
    if (jumlah > barang.stock) {
      print("\nTransaksi gagal, jumlah beli $jumlah melebihi stok yang tersisa ${barang.stock}");
    } else if (jumlah <= 0) {
      print("\nJumlah beli harus lebih dari 0!");
    }

    //menentukan persen potongan
    double persenPotongan = 0;
    if (member && (hargaSatuan > 500000)){
      persenPotongan = 0.15;
    } else if (hargaSatuan > 200000) {
      persenPotongan = 0.1;
    } else if (hargaSatuan > 100000) {
      persenPotongan = 0.05;
    }

    //dapat potongan berapa Rp dan juga harga yang harus dibayar
    double nominalPotongan = hitungNominalPotongan(totalAwal, persenPotongan);
    double hargaAkhir = bayarAkhir(jumlah, hargaSatuan, persenPotongan);

    //mengurangi stok
    // barang.jual(jumlah);

    //struk transaksi
    print("\n=== TRANSAKSI ===");
    print('Member            : ${member ? "Ya" : "Tidak"}');
    print('Nama barang       : ${barang.namaBarang}');
    print('Harga satuan      : ${formatRupiah.format(hargaSatuan)}');
    print('Jumlah beli       : $jumlah');
    print('Total belanja awal: ${formatRupiah.format(totalAwal)}');
    print('Potongan          : ${(persenPotongan * 100).toStringAsFixed(0)}%');
    print('Nominal potongan  : ${formatRupiah.format(nominalPotongan)}');
    print('=' * 28);
    print('Total harga akhir : ${formatRupiah.format(hargaAkhir)}');
    print('Sisa stok         : ${barang.stock}');
    barang.jual(jumlah);
    print('='*28);
  } catch(e) {
    print("Terjadi kesalahan, membatalkan transaksi");
  } finally {
    print("Transaksi dicatat di log.");
  }
}

//mencari barang di dalam list.
void totalStock(List<Barang> daftarBarang, String namaBarang, int stock) {
  int index = daftarBarang.indexWhere(
    (b) => b.namaBarang.toLowerCase() == namaBarang.toLowerCase(),
  );

  if (index != -1) {
    Barang barangTerpilih = daftarBarang[index];
    num hargaBarang = barangTerpilih.hargaUmum;
    num total = stock * hargaBarang;
    print("\n===== TOTAL STOCK =====");
    print("${barangTerpilih.namaBarang}: $stock x ${formatRupiah.format(hargaBarang)} = ${formatRupiah.format(total)}",);
  } else {
    print("Barang '$namaBarang' tidak ditemukan!");
  }
}

//menampilkan daftar barang yang stoknya menipis
void lowStock(List<Barang> daftarBarang) {
  print("\n==== STOK MENIPIS ====");
  for (var barang in daftarBarang) {
    if (barang._stock < 5) {
      print("${barang.namaBarang}: sisa ${barang._stock} pcs (Kategori: ${barang.kategori})");
    }
  }
}

Future<void>muatLaporan() async {
  print('\nMenyiapkan laporan');
  await Future.delayed(Duration(seconds: 1));
  print('\nLaporan Siap!');
}

void main() async {
  await muatLaporan();

  Barang bukuTulis = Barang(
    namaBarang: "Buku Tulis",
    hargaMember: 3000.0,
    hargaUmum: 3500.0,
    stock: 3,
    kategori: "atk",
  );
  // bukuTulis.tambahStok(10);

  Barang pulpen = Barang(
    namaBarang: "Pulpen",
    hargaMember: 2500.0,
    hargaUmum: 3000.0,
    stock: 10,
    kategori: "atk",
  );

  Barang roti = Barang(
    namaBarang: "Roti",
    hargaMember: 2000.0,
    hargaUmum: 2500.0,
    stock: 2,
    kategori: "makanan",
  );

  BarangPromo rotiLapis = BarangPromo(
    namaBarang: "Roti lapis",
    hargaMember: 5000.0,
    hargaUmum: 6000.0,
    stock: 10,
    kategori: "makanan",
    diskonPromo: 0.2,
  );

  List<Barang> koperasi = [bukuTulis, pulpen, roti ,rotiLapis];

  print("\n===| DAFTAR BARANG KOPERASI BRANTAS MART |===");
  for (var barang in koperasi) {
    barang.tampilkanKartuBarang();
  }
  daftarBarangBernomor(koperasi);
  transaksi(bukuTulis, true, "dua");
  transaksi(pulpen, true, "1");
  totalStock(koperasi, "Buku Tulis", bukuTulis.stock);
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
