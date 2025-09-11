//Buatlah sebuah program yang dapat menampilkan bilangan prima dari angka 0 sampai 201 menggunakan Dart. Ketika bilangan prima ditemukan, maka tampilkan nama lengkap dan NIM Anda.
import 'dart:math';

void main(){
  for (var i = 0; i < 202; i++) {
    if (isPrime(i)) {
      print("$i adalah bilangan prima. Nama: Rizqi Fauzan, NIM: 23341720143");
    }else{
      print("$i bukan bilangan prima.");
    }
  }
}

bool isPrime(int number) {
  if (number <= 1) {
    return false;
  }
  for (var i = 2; i <= sqrt(number); i++) {
    if (number % i == 0) {
      return false;
    }
  }
  return true;
}