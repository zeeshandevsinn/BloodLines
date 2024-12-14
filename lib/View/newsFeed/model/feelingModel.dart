import 'package:map_location_picker/map_location_picker.dart';

class FeelingClass {
  String? image;
  String? name;
  String? type;

  FeelingClass({this.image, this.name, this.type});
}



List<FeelingClass> feelingList = [
  FeelingClass(
      image: "assets/feeling/smile.png", name: "Happy", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/angry.png", name: "Angry", type: "Feeling"),
  FeelingClass(image: "assets/feeling/sad.png", name: "Sad", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/loving.png", name: "Loving", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/scared.png", name: "Scared", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/sleeping.png", name: "Sleepy", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/relax.png", name: "Relax", type: "Feeling"),
  FeelingClass(
      image: "assets/feeling/surprised.png",
      name: "Surprised",
      type: "Feeling"),
];
List<FeelingClass> activityList = [
  FeelingClass(
      image: "assets/feeling/clean.png", name: "Cleaning", type: "Activity"),
  FeelingClass(
      image: "assets/feeling/eat.png", name: "Eating", type: "Activity"),
  FeelingClass(
      image: "assets/feeling/date.png", name: "Dating", type: "Activity"),
  FeelingClass(
      image: "assets/feeling/exercise.png",
      name: "Exercising",
      type: "Activity"),
  FeelingClass(
      image: "assets/feeling/gaming.png", name: "Gaming", type: "Activity"),
  FeelingClass(
      image: "assets/feeling/reading.png", name: "Reading", type: "Activity"),
  FeelingClass(
      image: "assets/feeling/shop.png", name: "Shopping", type: "Activity"),
];
