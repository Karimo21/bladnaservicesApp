import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with WidgetsBindingObserver {
  late IO.Socket socket;
  Function(dynamic)? onMessageReceived;

  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal() {
    WidgetsBinding.instance.addObserver(this);
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io('http://localhost:3000', 
        IO.OptionBuilder().setTransports(['websocket']).build());
    
    socket.onConnect((_) {
      print('Connected to Socket Server');
    });

    socket.on('receiveMessage', (data) {
      if (onMessageReceived != null) {
        onMessageReceived!(data);
      }
    });

    socket.onDisconnect((_) => print('Disconnected from Socket Server'));
  }

  // 📌 Gérer le cycle de vie de l'application
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _disconnectSocket(); // Déconnexion propre sans tuer la socket
    } else if (state == AppLifecycleState.resumed) {
      _reconnectSocket(); // Reconnexion automatique en cas de retour
    } else if (state == AppLifecycleState.detached) {
      dispose(); // Fermeture complète lorsque l'application est détruite
    }
  }

  void _disconnectSocket() {
    if (socket.connected) {
      socket.disconnect(); // Déconnexion propre sans fermer totalement
      print('🔌 Socket déconnecté temporairement.');
    }
  }

  void _reconnectSocket() {
    if (!socket.connected) {
      socket.connect(); // Reconnexion automatique
      print('🔄 Socket reconnecté.');
    }
  }

  void sendMessage(int senderId, int receiverId, String message, String time) {
    socket.emit('sendMessage', {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "time": time,
    });
  }
  void markMessagesAsRead(int userId, int contactId) {
  socket.emit('markMessagesAsRead', {
    "userId": userId,
    "contactId": contactId
  });
}

  void joinRoom(int userId,) {
    socket.emit('join', userId);
  }

  void setOnMessageReceived(Function(dynamic) callback) {
    onMessageReceived = callback;
  }

void setOnContactsUpdated(Function(List<dynamic>) callback) {
  socket.on('contactsUpdated', (data) {
    print("Before callback");
    
    if (data is Map<String, dynamic> && data.containsKey('contacts')) {
      // Extract the contacts list and pass it to the callback
      if (callback != null) {
        callback(data['contacts']);
      }
    } else {
      print("Invalid data format received: $data");
    }

    print("After callback");
  });
}


  void dispose() {
    socket.disconnect(); // Déconnexion propre
    socket.dispose(); // Fermeture complète
    WidgetsBinding.instance.removeObserver(this); // Supprimer l'observateur
    print("🔴 Socket fermé définitivement.");
  }
}
