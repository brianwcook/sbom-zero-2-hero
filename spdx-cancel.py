import json
import sys

def read_json_file(file_name):
    """Read a JSON file and return its content as a dictionary."""
    try:
        with open(file_name, 'r') as file:
            data = json.load(file)
        return data
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: File '{file_name}' is not a valid JSON file.")
        sys.exit(1)



def find_unique_names(list1, list2):
    # Extract names from each list into sets
    if len(list1) > len(list2):
        larger_list, smaller_list = list1, list2
    else:
        larger_list, smaller_list = list2, list1
    
    names_set1 = {d['name'] for d in larger_list}
    names_set2 = {d['name'] for d in smaller_list}
    
    # Find names unique to each list
    unique_to_list1 = names_set1 - names_set2
    unique_to_list2 = names_set2 - names_set1
    
    # Build the resulting dictionary
    result = {
        'unique_to_list1': list(unique_to_list1),
        'unique_to_list2': list(unique_to_list2)
    }
    
    return result


def filter_dicts_by_names(name_list, dict_list):
    # Convert the list of names to a set for efficient lookup
    name_set = set(name_list)
    
    # Filter dictionaries based on the presence of 'name' in the set
    filtered_dict = {i: d for i, d in enumerate(dict_list) if d['name'] in name_set}
    
    return filtered_dict


def main(file1, file2):
    """Main function to handle reading two JSON files and converting them to dictionaries."""
    dict1 = read_json_file(file1)
    dict2 = read_json_file(file2)

    pkg_diff = find_unique_names(dict1['packages'], dict2['packages'])
    # print(str(json.dumps(pkg_diff)))


    filtered_dict = filter_dicts_by_names(pkg_diff["unique_to_list1"], dict2['packages'])
    print(json.dumps(filtered_dict))



if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <file1.json> <file2.json>")
        sys.exit(1)
    
    file1 = sys.argv[1]
    file2 = sys.argv[2]
    
    main(file1, file2)
