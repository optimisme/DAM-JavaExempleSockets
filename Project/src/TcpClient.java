import java.io.EOFException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class TcpClient {

    private static Scanner in = new Scanner(System.in);

    public static void main(String[] args) {
        
        String hostName = "127.0.0.1";
        int port = 4321;
        boolean running = true;

        Socket socket = null;
        ObjectInputStream ois = null;
        ObjectOutputStream oos = null;

        // Iniciar canals de comunicació amb el servidor
        try {
            socket = new Socket(hostName, port);
            oos = new ObjectOutputStream(socket.getOutputStream());
            ois = new ObjectInputStream(socket.getInputStream());

        } catch (IOException e) { e.printStackTrace(); }

        // Comunicar-se amb el servidor
        while (running) { running = run(oos, ois); }

        // Tancar connexió
        try {
            if (ois != null) ois.close();
            if (oos != null) oos.close();
            if (socket != null) socket.close();
            System.out.println("Client tancat");
        } catch (IOException e) { e.printStackTrace(); }    
    }

    // Comunicar-se amb el servidor
    static public boolean run (ObjectOutputStream oos, ObjectInputStream ois) {
        boolean running = true;
        String message = "";
        try {

            // Enviar un missatge al servidor
            System.out.print("Escriu un missatge pel servidor: ");
            String text = in.nextLine();
            oos.writeObject(text);
    
            // Rebre resposta del servidor
            message = (String) ois.readObject();
            System.out.println("El servidor ha respost: " + message);
    
            // Si l'usuari vol acabar la connexió
            if (message.contains("tancar")) { running = false; }
    
        } catch (EOFException e) {
            running = false;
        } catch (IOException | ClassNotFoundException e) { 
            e.printStackTrace(); 
            running = false;
        }

        return running;
    }
}