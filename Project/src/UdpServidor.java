import java.net.*;
import java.io.*;
class UdpServidor
{
    public static void main(String args[])  {

        try {
            System.out.println("LocalHost = " + InetAddress.getLocalHost().toString());
        } catch (UnknownHostException uhe) {
            System.err.println("No s'ha pogut obrir la direcció local :" + uhe); 
        }

        int port = 4456;
        DatagramSocket socket = null;
        try {
            socket = new DatagramSocket(port);
        } catch(SocketException e) {
            System.err.println("No s'ha pogut obrir el socket al port: " + port);
            System.exit(-1);
        }

        DatagramPacket dp = null;
        boolean running = true;

        while (running) {
            try {
                // Creem un buffer per rebre un Integer en forma de byte[] i el llegim
                byte bufferEntrada[] = new byte[Integer.BYTES];
                dp = new DatagramPacket(bufferEntrada, bufferEntrada.length);
                socket.receive(dp);
                int missatgeRebut = transformaBytesAInt(bufferEntrada);

                // Transformem el resultat en 8 bytes (un long)
                long missatgeEnviat = (long) missatgeRebut * (long) missatgeRebut;
                byte[] bytesEnviament = transformaLongABytes(missatgeEnviat);
                
                // Enviem el paquet amb les dades al client que correspon
                int portClient = dp.getPort();
                InetAddress ipClient = dp.getAddress();
                dp = new DatagramPacket(bytesEnviament, bytesEnviament.length, ipClient, portClient);
                socket.send(dp);

                System.out.println( "Client=" + ipClient + ":" + portClient + "\tEntrada=" + missatgeRebut + "\tEnviament=" + missatgeEnviat );

            } catch (IOException e) { 
                e.printStackTrace(); 
                running = false;
            }
        }
        if (socket != null) socket.close();
    }

    static public byte[] transformaLongABytes (long valor) {
        byte[] resultat = null;
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            DataOutputStream dos = new DataOutputStream(baos);
            dos.writeLong(valor);
            dos.close();
            resultat = baos.toByteArray();
        } catch (IOException e) { e.printStackTrace();  }
        return resultat;
    }

    static public int transformaBytesAInt (byte[] dades) {
        int resultat = 0;
        try {
            ByteArrayInputStream bais = new ByteArrayInputStream(dades);
            DataInputStream dis = new DataInputStream(bais);
            resultat = dis.readInt();
        } catch (IOException e) { e.printStackTrace(); }
        return resultat;
    }
}