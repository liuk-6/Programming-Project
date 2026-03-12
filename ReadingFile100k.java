import java.io.File;
import java.util.Scanner;

class flights100k{

    public static void main(String[] args) {

        try {
            File file = new File("flights100k.csv");
            Scanner scanner = new Scanner(file);

            while(scanner.hasNextLine()) {
                String line = scanner.nextLine();
                System.out.println(line);
            }

            scanner.close();

        } catch (Exception e) {
            System.out.println("Error reading file");
        }
    }
}

