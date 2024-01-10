import java.io.*;
import java.net.*;
import java.util.Random;

public class LoadBalancer extends Thread{

    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081,8082};
    static int nbHosts = 2;
    static Random rand = new Random();

    Socket client_input;

    public LoadBalancer(Socket s){
        this.client_input = s;
    }

    public void run(){

        try {

            System.out.println("Connection established: Starting load balancer ...");

            InputStream client_in_stream = client_input.getInputStream();
            OutputStream client_out_stream = client_input.getOutputStream();
            
            int i = rand.nextInt(nbHosts);
            Socket comanche_output = new Socket(hosts[i], ports[i]);
            InputStream server_in_stream = comanche_output.getInputStream();
	  		OutputStream server_out_stream = comanche_output.getOutputStream();

            // Get call from client reading the message and send it to the server
            byte[] buffer = new byte[1024];
            int bytesRead = client_in_stream.read(buffer);
            server_out_stream.write(buffer, 0, bytesRead);
            
            // Read info from server and send it to client
            bytesRead = server_in_stream.read(buffer);
            client_out_stream.write(buffer, 0, bytesRead);

            client_in_stream.close();
            client_out_stream.close();
            server_in_stream.close();
            server_out_stream.close();

            client_input.close();
            comanche_output.close();

            System.out.println("Connection closed: End of load balancer ...");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
        
    public static void main(String[] args) {
        
        try {
            ServerSocket ss = new ServerSocket(8080);

            while (true) {
                Socket s = ss.accept();

                System.out.println("Demanding communication ...");

                LoadBalancer ld = new LoadBalancer(s);
                ld.start();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}