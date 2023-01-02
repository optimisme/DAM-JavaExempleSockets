import java.io.*;
import java.net.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class TcpServidor {

    static private ExecutorService executor = Executors.newFixedThreadPool(100);

    public static void main(String args[]) {

        int port = 4321;
        ServerSocket serverSocket = null;
        boolean running = true;

        // Inicia el sevidor de sockets
        try {
            serverSocket = new ServerSocket(port);
            System.out.println("Servidor funcionant al port: " + port);
        } catch (IOException e) { e.printStackTrace(); }

        // Espera i assigna noves connexions
        while (running) {
            try {
                TcpServidor.clientConnection(serverSocket.accept());
                System.out.println("Nou client connectat");
            } catch (IOException e) { e.printStackTrace(); }
        }

        // Tancar els fils i el servidor de sockets (aquí no hi arriba mai)
        try {
            executor.shutdown();
            serverSocket.close();
        } catch (IOException e) { e.printStackTrace(); }
    }

    // Gestiona les connexions de sockets de cada client
    static public Future<Integer> clientConnection(Socket socket) {
        return (Future<Integer>) executor.submit(() -> {
            // Obrir els canals de comunicació amb el client
            ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
            ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
            boolean running = true;

            // Comunicar-se amb el client
            while (running) { running = run(ois, oos); }

            // Tancar socket amb el client
            ois.close();
            oos.close();
            socket.close();
            System.out.println("Client tancat");
            return 0;
        });
    }

    // Comunicar-se amb el client
    static public boolean run (ObjectInputStream ois, ObjectOutputStream oos) {
        boolean running = true;
        try {
            // Esperar a rebre un missatge del client
            System.out.println("Esperant petició del client");
            String message = (String) ois.readObject();
            System.out.println("El servidor ha rebut: " + message);

            // Donar resposta al missatge del client
            oos.writeObject("Resposta del servidor al missatge \"" + message + "\"");

            // Si el client vol acabar la connexió
            if (message.contains("tancar")) { running = false; }

        } catch (SocketException | EOFException e) { 
            System.out.println("El client ha desaparegut");
            running = false;
        } catch (IOException | ClassNotFoundException e) { 
            e.printStackTrace();
            running = false;
        }
        return running;
    }
}