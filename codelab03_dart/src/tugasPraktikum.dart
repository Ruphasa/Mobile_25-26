//Buatlah sebuah program yang dapat menampilkan bilangan prima dari angka 0 sampai 201 menggunakan Dart. Ketika bilangan prima ditemukan, maka tampilkan nama lengkap dan NIM Anda.
void main(){
  for (var i = 0; i < 202; i++) {
    if (i == 2 || i == 3 || i == 5){
      print("$i adalah bilangan prima - Nama: Your Name, NIM: Your NIM");
    } else if (i % 2 != 0 && i % 3 != 0 && i % 5 != 0 && i != 1){
      print("$i adalah bilangan prima - Nama: Your Name, NIM: Your NIM");
    }
  }
}