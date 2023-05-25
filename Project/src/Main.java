import java.io.IOException;
import java.util.*;

public class Main {

    static Scanner in = new Scanner(System.in); // System.in és global, Scanner també ho a de ser

    // Main
    public static void main(String[] args) throws InterruptedException, IOException {
        
        boolean running = true;

        while (running) {

            String menu = "Escull una opció:";
            menu = menu + "\n 0) Servidor UDP";
            menu = menu + "\n 1) Client UDP";
            menu = menu + "\n 2) Servidor TCP";
            menu = menu + "\n 3) Client TCP";
            menu = menu + "\n 4) Servidor WebSockets";
            menu = menu + "\n 5) Client WebSockets";
            menu = menu + "\n 6) Client GUI WebSockets";
            menu = menu + "\n 7) Sortir";
            System.out.println(menu);

            int opcio = Integer.valueOf(llegirLinia("Opció:"));
            
            switch (opcio) {
                case 0: UdpServidor.main(args);     break;
                case 1: UdpClient.main(args);       break;
                case 2: TcpServidor.main(args);     break;
                case 3:	TcpClient.main(args);       break;			
                case 4:	WsServidor.main(args);      break;			
                case 5:	WsClient.main(args);        break;			
                case 6:	WsClientGui.main(args);     break;			
                case 7: running = false;            break;
                default: break;
            }
        }

		in.close();
    }

    static public String llegirLinia (String text) {
        System.out.print(text);
        return in.nextLine();
    }
}