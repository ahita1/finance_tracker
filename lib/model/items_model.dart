class Items {
  final String img;
  final String title;
  final String subTitle;
  Items({
    required this.img,
    required this.title,
    required this.subTitle,
  });
}
List<Items> listOfItems = [
   Items(
    img: "assets/1.png",
    title: "Welcome To Horra Trading",
    subTitle:
        "There are 25.000+ best medical\njobs and schools, choose your\nchoice now",
  ),
  Items(
    img: "assets/2.png",
    title: "Want To Track Your Incomes!",
    subTitle:
        "There are 25.000+ best medical\njobs and schools, choose your\nchoice now",
  ),
  Items(
    img: "assets/3.png",
    title: "What about Your Expenses",
    subTitle:
        "There will be many people who\n want hear your stories and\n experiences",
  ),
  Items(
    img: "assets/4.png",
    title: "Tired Of Manage Your Balance ",
    subTitle: "Make your friendship and create a\nnew community",
  ),
];
