const io = require('socket.io-client');

// Connect to your server
const socket = io('http://localhost:3000');

// Listen for the connection
socket.on('connect', () => {
    console.log('Connected to the server');
    
    // Send a message to the server with sender_id and receiver_id
    const messageData = {
        sender_id: 1,  // Sender's ID
        receiver_id: 2,  // Receiver's ID
        message: 'Hello from sender 1 to receiver 2',
        time: new Date().toISOString()  // Send the current time as an example
    };
    
    socket.emit('sendMessage', messageData);
});

// Listen for messages from the server
socket.on('receiveMessage', (data) => {
    console.log('Received message from server:', data);
});
