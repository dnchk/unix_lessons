import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;

public class Main {
    public static void print_help() {
	System.out.println("Usage: java Main SOURCE_DIR");
	System.out.println("Sort all the files in a SOURCE_DIR into subdirectories named by file extension");
    }

    public static void main(String[] args) {
	if (args.length != 1) {
	    print_help();
	    System.exit(1);
	}

	if (args[0].equals("-h") || args[0].equals("--help")) {
	    print_help();
	    System.exit(0);
	}

	Path source_dir = Paths.get(args[0]);
	if (!Files.isDirectory(source_dir)) {
	    System.out.println("There's no such directory as provided param");
	    System.exit(1);
	}

	File[] files = new File(source_dir.toString()).listFiles();

	for (File file : files) {
	    if (!file.isDirectory()) {
		int i = file.getName().lastIndexOf('.');

		if (i > 0) {
		    File new_dir = new File(source_dir + "/" +
			file.getName().substring(i + 1));

		    if (!new_dir.exists()) {
			new_dir.mkdir();
		    }

		    File new_path = new File(new_dir + "/" + file.getName());
		    file.renameTo(new_path);
		}
	    }
	}
    }
}
