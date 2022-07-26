import 'database.dart';
import 'discogs.dart';
import 'spotify.dart';

class Test {
  static void fillDatabase() {
    // Database.clear();
    // Database.fillartists();
    // Database.startingData();
  }

  static void spotify() {
    // Spotify.authenticate();
    // Spotify.search("closer");
    // Spotify.albumsBy("26VFTg2z8YR0cCuwLzESi2");
    // Spotify.album("1hlapolkCnQLMgKcKNVCuc"); // Manic
    // Spotify.album("2XWgddMTqKo8YGj02MK4X2"); // For My Parents
    // Spotify.album("5IZ3qMtXKXAleWBxB7vWen"); // Closer

    // Halsey: 26VFTg2z8YR0cCuwLzESi2
  }

  static void discogs() {
    // Collection.artistData("4298621");
    // Collection.getTracks("girls");

    // Collection.barcode("602547866813").then((value) => Spotify.barcode(
    //     value[0][0][0].toString().replaceAll(RegExp(r'\([0-9]+\)'), ""),
    //     value[1].toString()));
    // Spotify.search("untitled");
    // Collection.barcode("656605321318");
    // Collection.barcode("634457649019");
    // Collection.barcode("888837168618");
    // Collection.barcode("656605560915");
    // Collection.barcode("4250795602507");

    // Collection.getAlbums("Ring Ring");

    // Collection.getArtists("Halsey");
    // Collection.getAlbums("Halsey");
    // Collection.search("Halsey");
    // Collection.artistData("4298621");

    // Collection.artistData("69866");
    // Collection.search("jasjie");
    // Collection.search("Jason Molina");
    // Collection.getArtists("Kanye");
    // Collection.search("Life of Pablo");

    // Collection.testing("Halsey");
    // Collection.testing("Jason Molina");

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

    // Kehlani: 3415529
    // Collection.getArtists("Kehlani");
    // Collection.albumsBy("3415529");
    // It Was Good Until It Wasn't
    // Collection.album("1773382"); // ID
    // Collection.album("15301268"); // main_release

    // Collection.album("1060029");
    // Collection.album("6045932");

    // Collection.album("1259172");
    // Collection.album("11067559");

    // Collection.album("1259174");
    // Collection.album("11067567");

    // Collection.album("1060033");
    // Collection.album("7345871");

    // Collection.album("1531444");
    // Collection.album("13302837");

    // Collection.album("16275882");

    // Collection.album("12680654");

    // Collection.album("14680833");

    // https://api.discogs.com/releases/8115775
    // https://api.discogs.com//artists/4298621/releases?sort=year

    // albumsBy(3415529) where results[j]["artist"] == "Kehlani" list of albumIDs
    var list = [
      6045932,
      11067559,
      11067567,
      7345871,
      11067610,
      10600393,
      11067602,
      9720490,
      13302837,
      15301424,
      15305496,
      15301268,
      23061677,
      12124509,
      13895167
    ];
    // for (int i = 0; i < list.length; i++) {
    //   Collection.album(list[i].toString());
    // }

    // ABBA: 69866
    // Collection.testing("ABBA", 1, {});
  }

  static void database() {
    // Database.pressingData(albumID: "139512361", numLP: "2", colorLP: "Colored");
    // Database.addNotes(
    //     albumID: "139512361",
    //     note:
    //         "This is Clairo's second album, but she released several EPs before her first.");

    // Database.getNotes("139512361").then((value) {
    //   value += " I really like this album.";
    //   Database.addNotes(albumID: "139512361", note: value);
    // });

    // Database.deleteNotes("139512361");

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
    // print("Testing");
    // Database.removeAlbum("20398592");
  }
}
