require('dotenv').config();
const express = require('express');
const cors = require('cors');
const http = require('http'); // Import http module
const bodyParser = require("body-parser");
const chatController = require('./controllers/chatController'); // Importer le contrôleur
const path = require('path');
const UserContact = require('./models/userContactsModel');
const app = express();
const server = http.createServer(app); // Create HTTP server with Express,while express handles http request naturaly,socket doesnt
const io = require('socket.io')(server, {  // Initialize socket.io with the HTTP server
  cors: {
    origin: "*",  // Adjust this based on the specific client URL in production
    methods: ["GET", "POST"]
  }
});

app.use(cors());
app.use(express.json({limit: "50mb"}));

// Augmenter la limite de taille de la requête
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));

// Serve static files from the 'uploads' directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

//routes
const userRoutes = require('./routes/userRoutes');
const chatRoutes = require('./routes/chatRoutes'); 
const reservationRoutes = require('./routes/reservationRoutes'); 

//use the user routes
app.use(userRoutes,reservationRoutes,chatRoutes);

io.on('connection', (socket) => {
    console.log('A user connected');

    socket.on('join', (data) => {
        socket.join(data); // Join the user's room
        const {userId,role} =data;
        console.log(`User with ID `,userId,`joined the room`,role);
    });
    
    // Listen for sendMessage event
    socket.on('sendMessage', async (data) => {
        try {
            const { senderId, receiverId, message, time } = data;

            // Appeler la méthode du contrôleur pour enregistrer le message en DB
            await chatController.createMessage(senderId, receiverId, message, time);

            

            // Diffuser le message à l'utilisateur récepteur
            io.to(receiverId).emit('receiveMessage', {
                "sender_id": senderId,
                "receiver_id":receiverId,
                message,
                time,
            });
            
        } catch (error) {
            console.error('Erreur lors de l\'envoi du message', error);
        }
    });
    socket.on('updateContacts', async (data) => {
        try {
            const {contactId,role} =data;
            console.log("its updating",contactId,"the role: ",role);
            
            // Update the client contacts 
            if(role == "client"){
              const updatedContacts = await UserContact.findClientContactsById(contactId);
              // Notify the relevant clients with the updated contact list
              io.to(contactId).emit('contactsUpdated', { success: true, contacts: updatedContacts });
            }
            if(role == "provider"){
             const updatedContacts = await UserContact.findProviderContactById(contactId);
             //Notify the relevant clients with the updated contact list
             io.to(contactId).emit('contactsUpdated', { success: true, contacts: updatedContacts });
            }
            

        } catch (error) {
            console.error('Error updating contacts:', error);
            socket.emit('contactsUpdated', { success: false, error: error.message });
        }
    });
    socket.on('markMessagesAsRead', async (data) => {
        try {
            const { userId, contactId } = data;
            
            // Marquer tous les messages comme lus dans la base de données
            await chatController.markAllMessagesAsRead(userId, contactId);
            
    
            // Notifier l'expéditeur que ses messages ont été lus
            io.to(contactId).emit('messagesMarkedAsRead', { 
                readerId: userId, 
                contactId 
            });
    
        } catch (error) {
            console.error('Erreur lors du marquage des messages comme lus:', error);
        }
    });
    

    // Listen for user disconnect
    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
});


const PORT = 3000;
server.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
 
