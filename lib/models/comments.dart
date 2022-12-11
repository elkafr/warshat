
class Comments {
  Comments({
    this.commentId,
    this.commentDetails,
    this.commentBy,
    this.commentDate,
    this.commentPhoto,
  });

  String commentId;
  String commentDetails;
  String commentBy;
  String commentDate;
  String commentPhoto;


  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    commentId: json["comment_id"],
    commentDetails: json["comment_details"],
    commentBy: json["comment_by"],
    commentDate: json["comment_date"],
    commentPhoto: json["comment_photo"],
  );

  Map<String, dynamic> toJson() => {
    "comment_id": commentId,
    "comment_details": commentDetails,
    "comment_by": commentBy,
    "comment_date": commentDate,
    "comment_photo": commentPhoto,
  };
}
