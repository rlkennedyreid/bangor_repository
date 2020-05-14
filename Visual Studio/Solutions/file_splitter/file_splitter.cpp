// file_splitter.cpp : This file contains the 'main' function. Program execution begins and ends there.

#include <iostream>
#include <fstream>
#include <string>

#include <boost/filesystem.hpp>


int assignHeaderAndDataNum(const std::string& events_file_directory, int& num_header_lines, int& num_data_rows)
{
	std::ifstream event_file{ events_file_directory };

	while (event_file.good())
	{
		std::string line;
		getline(event_file, line);

		if (line.size() != 0)
		{
			if (line.front() == '%') num_header_lines++;

			else num_data_rows++;
		}
	}

	event_file.close();

	return num_header_lines;
}

void outputHeaderFile(const std::string& events_file_directory, const std::string& output_directory, int num_header_lines)
{
	std::ifstream event_file{ events_file_directory };
	std::ofstream output_file{ output_directory + "header_file.txt" };

	for (int i{ 0 }; i < num_header_lines && event_file.good() && output_file.good(); i++)
	{
		std::string line;

		if (getline(event_file, line)) output_file << line << std::endl;

	}

	event_file.close();
	output_file.close();
}

class file_writer
{
public:

	file_writer() = delete;

	file_writer(
		const std::string& input_file,
		const std::string& output_file,
		int num_rows_per_section,
		int overlap_num,
		int num_header_lines)
		: _input_file_directory(input_file),
		_output_file_directory(output_file),
		_num_rows_per_section(num_rows_per_section),
		_overlap_num(overlap_num),
		_num_header_lines(num_header_lines)
	{}

	void write()
	{
		std::ifstream input_file{ _input_file_directory };

		// skip header
		for (int i{ 0 }; i < _num_header_lines && input_file.good(); i++)
		{
			std::string line;
			getline(input_file, line);
		}

		int current_file{ 0 };
		int sub_row_count{ 0 };

		std::string line;
		while (input_file.good() && getline(input_file, line))
		{

			std::string prefix{ "events_" };
			std::string suffix{ ".pos" };

			std::ofstream output_file;
			std::string output_file_name = _output_file_directory + prefix + std::to_string(current_file) + suffix;

			if (!_made_first_file)
			{
				boost::filesystem::copy_file(_output_file_directory + "header_file.txt", output_file_name, boost::filesystem::copy_option::overwrite_if_exists);
				_made_first_file = true;
			}
			output_file.open(output_file_name, std::ofstream::app);

			if (output_file.good())
			{
				output_file << line << std::endl;
				sub_row_count++;
			}
			if (sub_row_count > _num_rows_per_section - _overlap_num)
			{
				std::ofstream next_file;
				std::string next_file_name = _output_file_directory + prefix + std::to_string(current_file + 1) + suffix;

				if (!_made_next_file)
				{
					boost::filesystem::copy_file(_output_file_directory + "header_file.txt", next_file_name, boost::filesystem::copy_option::overwrite_if_exists);
					_made_next_file = true;
				}

				next_file.open(next_file_name, std::ofstream::app);
				next_file << line << std::endl;
				next_file.close();
			}
			if (sub_row_count == _num_rows_per_section)
			{
				sub_row_count = _overlap_num;
				current_file++;
				_made_next_file = false;
			}

			output_file.close();
		}

		input_file.close();
	}

private:

	const std::string& _input_file_directory;
	const std::string& _output_file_directory;
	const int _num_rows_per_section;
	const int _overlap_num;
	const int _num_header_lines;
	bool _made_first_file = false;
	bool _made_next_file = false;

};

void MakeOutputPath(const std::string& output_folder_directory)
{
	auto output_path = boost::filesystem::path{ output_folder_directory };

	auto path_exists = boost::filesystem::exists(output_path);

	if (!path_exists)
		boost::filesystem::create_directories(output_path);
}

std::string GetStringInput(const std::string& input_message)
{
	std::cout << input_message << std::endl;

	std::string input;

	getline(std::cin, input);

	return input;
}

int GetIntInput(const std::string& input_message)
{
	std::cout << input_message << std::endl;

	int input;

	std::cin >> input;

	return input;
}

int main()
{

	// "C:/Users/rbk20xqk/Documents/ugcs-emlid test001/OUTPUT/M_202004051759_events.pos"
	// "C:/Users/rbk20xqk/Documents/file_system2/"

	std::string events_file_directory = GetStringInput("Give events file directory (include file name)\nUse forward slashes!");
	std::string output_folder_directory= GetStringInput("Give output folder directory\nUse forward slashes, end with a final slash");

	int num_rows_per_section;
	int overlap_num;

	do
	{
		num_rows_per_section = GetIntInput("Give number of events per sub-file (numbers only)");
		overlap_num = GetIntInput("Give desired number of overlap events between files (numbers only)");
	}
	while (overlap_num > num_rows_per_section);

	MakeOutputPath(output_folder_directory);

	int num_header_lines{ 0 };
	int num_data_rows{ 0 };
		
	assignHeaderAndDataNum(events_file_directory, num_header_lines, num_data_rows);

	outputHeaderFile(events_file_directory, output_folder_directory, num_header_lines);

	file_writer(events_file_directory, output_folder_directory, num_rows_per_section, overlap_num, num_header_lines).write();

}