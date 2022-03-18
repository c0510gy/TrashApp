class TrashCan {
  int? num;
  String? districtName;
  String? streetName;
  String? location;
  late final String hash;
  TrashCan({this.num, this.districtName, this.streetName, this.location}) {
    hash = '${num?.toString() ?? ''}${districtName}${streetName}${location}';
  }

  factory TrashCan.fromCSVRow(List<dynamic> row) {
    return TrashCan(
      num: int.tryParse(row[0].toString()),
      districtName: row[1].toString().replaceAll('\n', ' '),
      streetName: row[2].toString().replaceAll('\n', ' '),
      location: row[3].toString().replaceAll('\n', ' '),
    );
  }
}
