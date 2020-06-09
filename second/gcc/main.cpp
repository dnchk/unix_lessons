#include <cstring>
#include <fstream>
#include <sstream>
#include <iostream>
#include <iterator>
#include <streambuf>
#include <algorithm>
#include <map>
#include <utility>
#include <experimental/filesystem>

using namespace std;
namespace fs = std::experimental::filesystem;

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

void print_help()
{
    cout << "Usage: task INPUT_DATA\n";
    cout << "Analyze the text from INPUT_DATA and select the 100 most common words\n";
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
    string text((istreambuf_iterator<char>(file)),
	istreambuf_iterator<char>());
    trim_html(text);

    string clean_text;
    remove_copy_if(text.begin(), text.end(),
	back_inserter(clean_text), ptr_fun<int, int>(&ispunct));
    clean_text.erase(remove(clean_text.begin(), clean_text.end(), '\"'),
	clean_text.end());

    istringstream iss(clean_text);
    vector<string> words{istream_iterator<string>{iss},
	istream_iterator<string>{}};

    map<string, int> frequency;
    for (auto w : words)
    {
	frequency[w]++;
    }

    vector<pair<string, int>> v_words = {};
    for (auto it = frequency.begin(); it != frequency.end(); ++it)
    {
	v_words.push_back(*it);
    }

    sort(v_words.begin(), v_words.end(),
	[=](pair<string, int>& a, pair<string, int>& b) {
	    return a.second > b.second;
	});

    ofstream out_file;
    out_file.open("out");

    for (int i = 0; i < 100; ++i)
    {
	out_file << get<1>(v_words[i]) << " " << get<0>(v_words[i])
	    << "\n";
    }

    out_file.close();

    return 0;
}
