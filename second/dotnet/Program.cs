using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace dotnet
{
    class Program
    {
	static void PrintHelp()
	{
	    Console.WriteLine("Usage: dotnet run -- INPUT_DATA");
	    Console.WriteLine("Analyze the text from INPUT_DATA and select the 100 most common words");
	}

        static void Main(string[] args)
        {
	    if (args.Length != 1)
	    {
		Console.Error.WriteLine("Usage: dotnet run -- INPUT_DATA, see -h");
		Environment.Exit(-1);
	    }

	    if (args[0] == "-h" || args[0] == "--help")
	    {
		PrintHelp();
		Environment.Exit(0);
	    }

	    string input = args[0];
	    if (!File.Exists(input))
	    {
		Console.Error.WriteLine("Param is not a file, see -h or --help");
		Environment.Exit(-1);
	    }

	    string html = System.IO.File.ReadAllText(input);
	    string raw_text = Regex.Replace(html, "<.*?>", String.Empty);
	    string text = Regex.Replace(raw_text, @"\n|\r", String.Empty);
	    var punctuation = text.Where(Char.IsPunctuation).Distinct().ToArray();
	    var words = text.Split().Select(x => x.Trim(punctuation));
	    words = words.Where(x => !string.IsNullOrEmpty(x)).ToArray();

	    var orderedWords = words.GroupBy(x => x).Select(x => new {
		    KeyField = x.Key,
		    Count = x.Count() })
		.OrderByDescending(x => x.Count).Take(100);

	    foreach (var i in orderedWords)
	    {
		string line = String.Format("{0} {1}", i.Count, i.KeyField);

		using (System.IO.StreamWriter file =
		    new System.IO.StreamWriter(@"./out", true))
		{
		    file.WriteLine(line);
		}
	    }
        }
    }
}
