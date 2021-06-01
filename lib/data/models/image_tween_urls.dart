import 'package:equatable/equatable.dart';

class ImageTweenUrls extends Equatable {
  String? placeHolderImageUrl;
  String? imageUrl;

  ImageTweenUrls({this.placeHolderImageUrl, this.imageUrl});

  @override
  // TODO: implement props
  List<Object?> get props => [placeHolderImageUrl, imageUrl];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}