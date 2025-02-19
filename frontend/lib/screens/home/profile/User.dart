class User {
  // Static variables to store user data globally
  static int userId =0;
  static String role = '';

  // Function to set the user data
  static void setUserData(int id, String userRole) {
    userId = id;
    role = userRole;
  }

  // Function to get the userId
  static int getUserId() {
    return userId;
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
