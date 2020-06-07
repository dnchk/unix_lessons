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

namespace fs = std::experimental::filesystem;

void trim_html(std::string& html)
{
    size_t a = 0, b = 0;
    for (a = b; a < html.length(); a++)
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
    std::cout << "Usage: task INPUT_DATA\n";
    std::cout << "Analyze the text from INPUT_DATA and select the 100 most common words\n";
}

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
	print_help();
	return 1;
    }

    if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0)
    {
	print_help();
	return 0;
    }

    std::string input = argv[1];

    if (!fs::exists(input))
    {
	std::cout << "Param is not a file, see -h or --help\n";
	return 1;
    }

    std::ifstream file(input);
    std::string text((std::istreambuf_iterator<char>(file)),
	std::istreambuf_iterator<char>());
    trim_html(text);

    std::string clean_text;
    std::remove_copy_if(text.begin(), text.end(),
	std::back_inserter(clean_text), std::ptr_fun<int, int>(&std::ispunct));
    clean_text.erase(remove(clean_text.begin(), clean_text.end(), '\"'),
	clean_text.end());

    std::istringstream iss(clean_text);
    std::vector<std::string> words{std::istream_iterator<std::string>{iss},
	std::istream_iterator<std::string>{}};

/* TODO optimize */
    std::map<std::string, int> frequency;
    for (auto w : words)
    {
	frequency[w]++;
    }

    std::vector<std::pair<std::string, int>> v_words = {};
    for (auto it = frequency.begin(); it != frequency.end(); ++it)
    {
	v_words.push_back(*it);
    }

    std::sort(v_words.begin(), v_words.end(),
	[=](std::pair<std::string, int>& a, std::pair<std::string, int>& b) {
	    return a.second > b.second;
	});

    for (int i = 0; i < 100; ++i)
    {
	std::cout << std::get<0>(v_words[i]) << " " << std::get<1>(v_words[i])
	    << "\n";
    }

    return 0;
}
