void main() {
  var record = (2, true);
  print(record);
  print(tukar(record));

  (String, int) mahasiswa;
  mahasiswa = ('Rizqi Fauzan', 2341720143);
  print(mahasiswa);

  var mahasiswa2 = ('Rizqi Fauzan', a: 2341720143, b: true, 'last');

  print(mahasiswa2.$1); // Prints 'first'
  print(mahasiswa2.a); // Prints 2341720143
  print(mahasiswa2.b); // Prints true
  print(mahasiswa2.$2); // Prints 'last'
}

(bool, int) tukar((int, bool) record) {
  var (a, b) = record;
  return (b, a);
}