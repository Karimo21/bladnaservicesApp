const twilio = require('twilio');

// Replace these with your Twilio account SID and Auth Token
const accountSid = 'AC96cbd4868607d4fd942c9a56f754b788';
const authToken = '651aa8df83a784b4341f330128b0cc40';
const verifyServiceSid = 'VAe53d94e3e4faabdfb8494a0fb088e589';

const client = new twilio(accountSid, authToken);

// Async function to send OTP
exports.sendOTP = async (req, res) => {
  try {
    const phoneNumber = req.body.phoneNumber;
    console.log(phoneNumber);

    // Ensure phoneNumber is provided
    if (!phoneNumber) {
      return res.status(400).json({ message: 'Phone number is required' });
    }
    

    // Send OTP via Twilio
    const verification = await client.verify.v2.services(verifyServiceSid)
      .verifications.create({
        to: phoneNumber,
        channel: 'sms'
      });

    console.log(`OTP sent to ${phoneNumber}: ${verification.status}`);

    // Respond with a success message
    return res.json({ message: 'OTP sent successfully' });

  } catch (error) {
    console.error('Error sending OTP:', error.message);
    return res.status(500).json({ message: error.message || 'Error sending OTP' });
  }
};

// Async function to verify OTP
exports.verifyOTP = async (req, res) => {
  try {
    const { phoneNumber, code } = req.body;

    // Ensure phoneNumber and code are provided
    if (!phoneNumber || !code) {
      return res.status(400).json({ message: 'Phone number and code are required' });
    }

    // Verify OTP using the code
    const verificationCheck = await client.verify.v2.services(verifyServiceSid)
      .verificationChecks.create({
        to: phoneNumber,
        code: code
      });

    if (verificationCheck.status === 'approved') {
      // Respond with success message
      return res.json({ message: 'OTP verified successfully' });
    } else {
      throw new Error('Invalid OTP');
    }

  } catch (error) {
    console.error('Error verifying OTP:', error.message);
    return res.status(500).json({ message: error.message || 'Error verifying OTP' });
  }
};
