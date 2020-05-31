using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace dotnet
{
    class Program
    {
	static string usage = "Usage: dotnet run -- INPUT_DATA";

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

	    string input = args[0];
	    if (!File.Exists(input))
	    {
		Console.WriteLine("Param is not a file, see -h or --help");
		Environment.Exit(-1);
	    }

	    string html = System.IO.File.ReadAllText(input);
	    string text = Regex.Replace(html, "<.*?>", String.Empty);
	    string[] words = text.Split(' ');

	    var orderedWords = words.GroupBy(x => x).Select(x => new {
		    KeyField = x.Key,
		    Count = x.Count() })
		.OrderByDescending(x => x.Count)
		.Take(100);

	    foreach (var i in orderedWords)
	    {
		Console.WriteLine(i);
	    }
        }
    }
}
