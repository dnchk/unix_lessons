import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Map;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;

public class Main {
    public static void print_help() {
	System.out.println("Usage: java Main INPUT_DATA");
	System.out.println("Analyze the text from INPUT_DATA and select the 100 most common words");
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

	File input = new File(args[0]);
	if (!input.exists()) {
	    System.out.println("File passed as param doesn't exist");
	    System.exit(1);
	}

	String content = "";
	try {
	    content = new Scanner(input).useDelimiter("\\Z").next();
	} catch (IOException e) {
	    e.printStackTrace();
	}

	content = content.replaceAll("\\<.*?\\>", "");

	String[] splitted = content.split("\\s+");
	Arrays.sort(splitted);

	ArrayList<String> list = new ArrayList<String>();

	for (int i = 0; i < splitted.length; ++i) {
	    if (!splitted[i].trim().equals("")) {
		list.add(splitted[i]);
	    }
	}

	Map<String, Long> map = list.stream().
	    collect(Collectors.groupingBy(w -> w, Collectors.counting()));

	List<Map.Entry<String, Long>> result = map.entrySet().stream().
	    sorted(Map.Entry.comparingByValue(Comparator.reverseOrder())).
	    limit(100).collect(Collectors.toList());

	try {
	    FileWriter file_writer = new FileWriter("out");

	    for (int i = 0; i < result.size(); ++i) {
		file_writer.write(result.get(i).getValue() + " "
		    + result.get(i).getKey() + "\n");
	    }

	    file_writer.close();
	} catch (IOException e) {
	    e.printStackTrace();
	}
    }
}
