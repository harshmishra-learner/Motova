/// Distinguishes which flow led to the OTP/Verification Success screens,
/// since both Sign Up and Forgot Password reuse the same two screens
/// but need to land somewhere different afterward.
enum OtpPurpose {
  signup,
  passwordReset,
}