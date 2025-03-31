class User {
  // Static variables to store user data globally
  static int userId =0;
  static String role = '';
  static String profile ="";
  static String fname="";
  static String lname="";
  static String ville="";
  static String description="";
  static String adresse="";
  static String rate="";
  static String service="";
  static int city=1;
  static int availability=0;
  static int totalreservations=0;
  

  // Function to set the user data
  static void setUserData(int id, String userRole,String profilePicture,String fname1,String lname1,String adresse1,String description1,
                          String rate1,int city1,int totalreservations1,String service1,int availability1
  ) {
    userId = id;
    role = userRole;
    profile=profilePicture;
    fname =fname1;
    lname=lname1;
    adresse=adresse1;
    description=description1;
    availability=availability1;
    rate=rate1;
    city=city1;
    totalreservations=totalreservations1;
    service=service1;
  }

  // Function to get the userId
  static int getUserId() {
    return userId;
  }
  static setProfile(String profile){
     profile=profile;
  }

  // Function to get the user role
  static String getRole() {
    return role;
  }

  // Function to clear user data (e.g., on logout)
  static void clearUserData() {
    userId = 0;
    role = '';
  }
}
