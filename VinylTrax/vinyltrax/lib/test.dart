import 'inventory/database.dart';
import 'discogs/discogs.dart';
import 'spotify/spotify.dart';
import 'camera/coverscan.dart';
import 'package:diacritic/diacritic.dart';

class Test {
  static void fillDatabase() async {
    // Database.clear();
    // Database.startingDiscogs();
  }

  static void spotify() {
    // Database.createAlbum(
    //     artist: ["Halsey", "26VFTg2z8YR0cCuwLzESi2"],
    //     album: "Bob's album",
    //     format: "Vinyl",
    //     year: "2019");
    // Database.addCategory("3sq0hRtlT2SYeYajr5Cx221", "Badass");
    // Database.displayByCategory("Badass", "Vinyl").then((value) {
    //   (value).forEach((element) {
    //     print(element[1].toString() + " BY " + element[2][0][0].toString());
    //   });
    // });
    // Database.displayByGenre("Pop", "Vinyl").then((value) {
    //   value.forEach((element) {
    //     print(element[1].toString() + " BY " + element[2][0][0].toString());
    //   });
    // });

    // Spotify.authenticate();
    // Spotify.search("closer");
    // Spotify.albumsBy("26VFTg2z8YR0cCuwLzESi2");
    // Spotify.album("1hlapolkCnQLMgKcKNVCuc"); // Manic
    // Spotify.album("2XWgddMTqKo8YGj02MK4X2"); // For My Parents
    // Spotify.album("5IZ3qMtXKXAleWBxB7vWen"); // Closer

    // Spotify.artist("26VFTg2z8YR0cCuwLzESi2");

    // Halsey: 26VFTg2z8YR0cCuwLzESi2
    // CoverScan.getOptions(
    //     "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");

    var barcodes = [
      "880882456917",
      "194398784816",
      "00602567701323",
      "4050486110485",
      "693461238510",
      "098787069013",
      "809236159014",
      // "60255703490", // No Reults Found
      "075597979381",
      "048612007710",
      "191402014518",
      "191402007312",
      "886977798313",
      "093624996651",
      "8718469535743",
      "5055667601768",
      "655003842340",
      "081227967451",
      "081227981631",
      "081227981600",
      "888837168618",
      "652637303810",
      "5013929175815",
      "8719262003392",
      "656605309910",
      "098787140514",
      "191401156417",
      // "8719262010314", // No Results Found
      "711297315417",
      "602557634945",
      "634457628618",
      "634457897618",
      "602508108587",
      "602508108259",
      "634904078010",
      "634904086817",
      "634904078201",
      "634904032418",
      "098787056518",
      "762183472028",
      "634457623613",
      "888750652010",
      "842803001637",
      // "759656064157", // No Results Found
      "825646658879",
      "076732168813",
      "808720333213",
      "098787085211",
      "098787084610",
      // "88750692719", // No Results Found
      "656605225517",
      // "655605220116", // No Results Found
      "711574510115",
      "767981108315",
      "045778654710",
      "656605031019",
      "673855077000", // No Results Found
      "634904086619",
    ];

    // barcodes.forEach((code) {
    //   Collection.barcode(code).then((value) {
    //     if (value.isNotEmpty) {
    //       // print(value[0]);
    //       // print("Artist: " +
    //       //     value[0][0][0].toString().replaceAll(RegExp(r'\([0-9]+\)'), "") +
    //       //     ",   Album: " +
    //       //     value[1].toString());
    //       Spotify.barcode(
    //               value[0][0][0]
    //                   .toString()
    //                   .replaceAll(RegExp(r'\([0-9]+\)'), ""),
    //               value[1].toString())
    //           .then((album) {
    //         if (album.isNotEmpty) {
    //           List<dynamic> al = [];
    //           al.add(album[6]);
    //           al.add("Vinyl");
    //           al += album;
    //           Database.addSpotToInv(al);
    //         }
    //       });
    //     }
    //   });
    // });
    // print(barcodes.length);
    // Spotify.barcode("", "");
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
