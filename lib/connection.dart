class Connection{

  var url = '';

  String getUrl() {
    //url = "10.1.1.70/testApi";                        //Local server
    url = "ha.e3m.ovh/testApi";   //Web server
    return url;
  }
}
Connection con = Connection();
