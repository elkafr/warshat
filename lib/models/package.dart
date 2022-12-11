class Package {
  Package({
    this.packageId,
    this.packageName,
    this.packagePrice,
    this.packagePeriod,
  });

  String packageId;
  String packageName;
  String packagePrice;
  String packagePeriod;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    packageId: json["package_id"],
    packageName: json["package_name"],
    packagePrice: json["package_price"],
    packagePeriod: json["package_period"],
  );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "package_name": packageName,
    "package_price": packagePrice,
    "package_period": packagePeriod,
  };
}