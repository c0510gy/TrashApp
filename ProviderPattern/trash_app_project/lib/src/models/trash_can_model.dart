class TrashCan {
  int? num;
  String? districtName;
  String? streetName;
  String? location;
  String? roadAddress;
  String? jibunAddress;
  String? englishAddress;
  double? x;
  double? y;

  late final String hash;
  TrashCan(
      {this.num,
      this.districtName,
      this.streetName,
      this.location,
      this.roadAddress,
      this.jibunAddress,
      this.englishAddress,
      this.x,
      this.y}) {
    hash = '${num?.toString() ?? ''}${districtName}${streetName}${location}';
  }

  factory TrashCan.fromCSVRow(List<dynamic> row) {
    return TrashCan(
      num: int.tryParse(row[0].toString()),
      districtName: row[1].toString().replaceAll('\n', ' '),
      streetName: row[2].toString().replaceAll('\n', ' '),
      location: row[3].toString().replaceAll('\n', ' '),
      roadAddress: row[4].toString(),
      jibunAddress: row[5].toString(),
      englishAddress: row[6].toString(),
      x: double.tryParse(row[7].toString()),
      y: double.tryParse(row[8].toString()),
    );
  }
}
