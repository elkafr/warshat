class UserDetails {
  UserDetails({
    this.userId,
    this.userPhone,
    this.userLocation,
    this.userEmail,
    this.userName,
    this.userDistance,
    this.userAdress,
    this.userWhats,
    this.userAbout,
    this.userTime,
    this.userActive,
    this.userType,
    this.userCat,
    this.userCatName,
    this.userCountry,
    this.userCity,
    this.userCityName,
    this.userCountryName,
    this.userPhoto,
    this.photos,
    this.userIsFavorite,
  });

  String userId;
  String userPhone;
  String userLocation;
  String userEmail;
  String userName;
  int userDistance;
  String userAdress;
  String userWhats;
  String userAbout;
  String userTime;
  String userActive;
  String userType;
  String userCat;
  String userCatName;
  String userCountry;
  String userCity;
  String userCityName;
  String userCountryName;
  String userPhoto;
  List<Photo> photos;
  int userIsFavorite;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    userId: json["user_id"],
    userPhone: json["user_phone"],
    userLocation: json["user_location"],
    userEmail: json["user_email"],
    userName: json["user_name"],
    userDistance: json["user_distance"],
    userAdress: json["user_adress"],
    userWhats: json["user_whats"],
    userAbout: json["user_about"],
    userTime: json["user_time"],
    userActive: json["user_active"],
    userType: json["user_type"],
    userCat: json["user_cat"],
    userCatName: json["user_cat_name"],
    userCountry: json["user_country"],
    userCity: json["user_city"],
    userCityName: json["user_city_name"],
    userCountryName: json["user_country_name"],
    userPhoto: json["user_photo"],
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    userIsFavorite: json["user_is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_phone": userPhone,
    "user_location": userLocation,
    "user_email": userEmail,
    "user_name": userName,
    "user_distance": userDistance,
    "user_adress": userAdress,
    "user_whats": userWhats,
    "user_about": userAbout,
    "user_time": userTime,
    "user_active": userActive,
    "user_type": userType,
    "user_cat": userCat,
    "user_cat_name": userCatName,
    "user_country": userCountry,
    "user_city": userCity,
    "user_city_name": userCityName,
    "user_country_name": userCountryName,
    "user_photo": userPhoto,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "user_is_favorite": userIsFavorite,
  };
}


class Photo {
  Photo({
    this.id,
    this.photo,
  });

  String id;
  String photo;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
  };
}