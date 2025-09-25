void main() {
  var gifts = {
    // Key:    Value
    'first': 'partridge',
    'second': 'turtledoves',
    'fifth': 1,
    'NIM': '2341720143',
    'Nama': 'Rizqi Fauzan'
  };

  var nobleGases = {2: 'helium', 10: 'neon', 18: 2, 'NIM': '2341720143', 'Nama': 'Rizqi Fauzan'};

  print(gifts);
  print(nobleGases);

  var mhs1 = <String, String>{};
  mhs1['NIM'] = '2341720143';
  mhs1['Nama'] = 'Rizqi Fauzan';
  gifts['first'] = 'partridge';
  gifts['second'] = 'turtledoves';
  gifts['fifth'] = 'golden rings';

  var mhs2 = <int, String>{};
  mhs2[1] = '2341720143';
  mhs2[2] = 'Rizqi Fauzan';
  nobleGases[2] = 'helium';
  nobleGases[10] = 'neon';
  nobleGases[18] = 'argon';

  print(mhs1);
  print(gifts);
  print(mhs2);
  print(nobleGases);


}
