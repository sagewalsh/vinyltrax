import 'database.dart';
import 'discogs.dart';

class Test {
  static void fillDatabase() {
    Database.startingData();
  }

  static void discogs() {
    // Collection.getArtists("Halsey");
    // Collection.getAlbums("Halsey");
    // Collection.search("Halsey");

    // Collection.search("jasjie");
    // Collection.search("Jason Molina");
    // Collection.getArtists("Kanye");
    // Collection.search("Life of Pablo");

    // Collection.search("For my Parents");

    // Kanye West: 137880
    // Collection.albumsBy("137880");

    // Jason Molina: 364910
    // Collection.albumsBy("364910");

    // Molina & Roberts: 1194500
    // Collection.album("1194500");

    // For My Parents: 3855676
    // Collection.album("3855676");

    // Halsey: 4298621

    // The life of pablo
    // Collection.album("8115775");

    // https://api.discogs.com/releases/8115775
    // https://api.discogs.com//artists/4298621/releases?sort=year
  }

  static void database() {
    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Album Data Given Valid ID: 1217\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumGivenID(1217);

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Album Data Given Invalid ID: 1000\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumGivenID(1000);

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Album Data Given Valid Name: Life of Pablo\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumGivenName("The Life of Pablo");

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Album Data Given Invalid Name: Spaghetti\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumGivenName("Spaghetti");

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nPrint all Albums Ordered By Album Name\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumsOrderName();

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nPrint all Albums Ordered By Artist Name\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumsOrderArtist();

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting an Artist Name Given Valid ID: 1112\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.artist(1112);

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting an Artist Name Given Invalid ID: 1000\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.artist(1000);

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Albums Made by Artist Given Valid Artist ID: 1112\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumsFrom(1112);

    // print("--------------------------------------------" +
    //     "--------------------------------------------" +
    //     "\nGetting Albums Made by Artist Given Invalid Artist ID: 1000\n" +
    //     "--------------------------------------------" +
    //     "--------------------------------------------");
    // Database.albumsFrom(1000);

    // Database.displayAlbum(1216);

    // Database.displayByArtist();

    // Database.albumsFrom(1112);
  }
}
