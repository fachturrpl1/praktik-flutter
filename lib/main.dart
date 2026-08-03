import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Barang {
  final String nama;
  final num hargaMember;
  final num hargaUmum;
  final int stock;
  bool get tersedia => stock > 0;
  num potongan = 0;
  final String kategori;
Barang({
  required this.nama,
  required this.hargaMember,
  required this.hargaUmum,
  required this.stock,
  required this.kategori,
});
}

final formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0
  );

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

void tampilkanKartuBarang(Barang barang1){
  print("\n=== KARTU DATA BARANG ===");
  print("nama barang: ${barang1.nama}");
  print("harga anggota: ${formatRupiah.format(barang1.hargaMember)}");
  print("harga umum: ${formatRupiah.format(barang1.hargaUmum)}");
  print("jumlah stok: ${barang1.stock}");
  print("tersedia: ${statusBarang(barang1.tersedia)}");
  print('Lokasi berada di: ${lokasiRak(barang1.kategori)}');
}

void transaksi(Barang barang1, member, totalHarga){
  num harga = 0;
  double potongan = 0;

  if (member) {
    harga = barang1.hargaMember;
  } else {
    harga = barang1.hargaUmum;
  }
  if (member && (totalHarga > 500000)){
    potongan = 0.15;
  } else if (totalHarga > 200000) {
    potongan = 0.1;
  } else if (totalHarga > 100000) {
    potongan = 0.05;
  }

  num hargaAkhir = totalHarga - (totalHarga * potongan);

  print("\n=== TRANSAKSI ===");
  print('Member: ${member ? "Ya" : "Tidak"}');
  print('Nama barang: ${barang1.nama}');
  print('Harga barang: ${formatRupiah.format(harga)}');
  print('Potongan: ${potongan*100}%');
  print('Total potongan: ${formatRupiah.format(totalHarga * potongan)}');
  print('Total belanja awal: ${formatRupiah.format(totalHarga)}');
  print('='*18);
  print('Total harga akhir: ${formatRupiah.format(hargaAkhir)}');

}

void main() {
  
  Barang barang1 = Barang(
    nama: "Buku Tulis",
    hargaMember: 3000.0,
    hargaUmum: 3500.0,
    stock: 40,
    kategori: "atk",
  );

  Barang barang2 = Barang(
    nama: "Roti",
    hargaMember: 2000.0,
    hargaUmum: 2500.0,
    stock: 100,
    kategori: "makanan",
  );

  tampilkanKartuBarang(barang1);
  tampilkanKartuBarang(barang2);

  transaksi(barang1, true, 700000);
  transaksi(barang1, false, 150000);
  transaksi(barang1, false, 50000);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Flutter Saya',// <------------- JUDUL APLIKASI
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepOrange).primaryContainer
      ),
      home: const MyHomePage(title: 'Ini adalah Header'),// <------------- JUDUL HEADER
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
