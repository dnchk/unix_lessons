#include <experimental/filesystem>
#include <algorithm>
#include <iterator>
#include <iostream>
#include <cstring>
#include <fstream>

using namespace std;
namespace fs = std::experimental::filesystem;

void print_help()
{
    cout << "Usage: task INPUT_DATA\n";
    cout << "Analyze the text from INPUT_DATA and select the 100 most common words\n";
}

void trim_html(string& html)
{
    size_t a = 0, b = 0;
    for (; a < html.length(); a++)
    {
	if (html[a] == '<')
	for (b = a; b < html.length(); b++)
	{
	    if (html[b] == '>')
	    {
		html.erase(a, (b - a + 1));
		break;
	    }
	}
    }
}

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
	cerr << "Usage: task INPUT_DATA, see -h or --help\n";
	return 1;
    }

    if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0)
    {
	print_help();
	return 0;
    }

    string input = argv[1];

    if (!fs::exists(input))
    {
	cerr << "Param is not a file, see -h or --help\n";
	return 1;
    }

    ifstream file(input);
    string text(istreambuf_iterator<char>{file}, istreambuf_iterator<char>{});
    trim_html(text);

    string clean_text;
    remove_copy_if(text.begin(), text.end(), back_inserter(clean_text),
	ptr_fun<int, int>(&ispunct));
    clean_text.erase(remove(clean_text.begin(), clean_text.end(), '\"'),
	clean_text.end());

    istringstream iss(clean_text);
    vector<string> words(istream_iterator<string>{iss},
	istream_iterator<string>{});

    vector<pair<string, int>> words_freq;
    int index;

    for (size_t i = 0; i < words.size(); ++i)
    {
	auto it = find_if(words_freq.begin(), words_freq.end(),
	    [&words, &i](const pair<string, int>& el)
	    {
		return el.first == words.at(i);
	    });

	if (it != words_freq.end())
	{
	    index = distance(words_freq.begin(), it);
	    words_freq.at(index).second++;
	}
	else
	{
	    words_freq.push_back(make_pair(words.at(i), 1));
	}
    }

    sort(words_freq.begin(), words_freq.end(),
	[=](pair<string, int>& a, pair<string, int>& b) {
	    return a.second > b.second;
	});

    ofstream out_file;
    out_file.open("out");

    for (size_t i = 0; i < 100; ++i)
    {
	out_file << words_freq.at(i).second << " " << words_freq.at(i).first
	    << "\n";
    }

    out_file.close();

    return 0;
}
