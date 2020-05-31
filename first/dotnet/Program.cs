using System;
using System.IO;

namespace dotnet
{
    class Program
    {
	static string usage = "Usage: dotnet run -- SOURCE_DIR";

        static void Main(string[] args)
        {
	    if (args.Length != 1)
	    {
		Console.WriteLine(usage);
		Environment.Exit(-1);
	    }

	    if (args[0] == "-h" || args[0] == "--help")
	    {
		Console.WriteLine(usage);
		Environment.Exit(0);
	    }

	    string source_dir = args[0];
	    if (!Directory.Exists(source_dir))
	    {
		Console.WriteLine("There's no such directory as provided param");
		Environment.Exit(-1);
	    }

	    string curr_path = Directory.GetCurrentDirectory();
	    string source_path = Path.Combine(curr_path, source_dir);

	    foreach (string file in Directory.GetFiles(source_path))
	    {
		string extension = Path.GetExtension(file);
		string new_dir = Path.Combine(source_path, extension.Substring(1));
		string new_path = Path.Combine(new_dir, Path.GetFileName(file));

		if (Directory.Exists(new_dir))
		{
		    Console.WriteLine("{0} already exists", new_dir);
		}
		else
		{
		    Directory.CreateDirectory(new_dir);
		    Console.WriteLine("{0} created", new_dir);
		}

		File.Move(file, new_path);
	    }
        }
    }
}
