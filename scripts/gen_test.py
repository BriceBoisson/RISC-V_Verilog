import re
import sys

if len(sys.argv) != 2:
    print("Usage: python3 gen_test.py <filename>")
    exit(1)

source_code = open(sys.argv[1], 'r')
Lines = source_code.readlines()
test_file = []

def get_test(test, instr_addr, final = False):
    result = ""

    pattern_r = re.compile(r'R\[(\d+)\]=([+-]?\d+)')
    pattern_pc = re.compile(r'PC=(\d+)')
    pattern_mem = re.compile(r'MEM\[(\d+)\]=([+-]?\d+)')

    # Use the patterns to search for matches in the input string
    match_r = pattern_r.search(test)
    match_pc = pattern_pc.search(test)
    match_mem = pattern_mem.search(test)

    if match_r:
        number1 = match_r.group(1)
        number2 = match_r.group(2)
        result = f"{number1}={number2}"
    elif match_pc:
        number_pc = match_pc.group(1)
        result = f"32={number_pc}"
    elif match_mem:
        number1_mem = match_mem.group(1)
        number2_mem = match_mem.group(2)
        result = f"{int(number1_mem) + 33}={number2_mem}"
    
    if result != "" and not final:
        result = f"{instr_addr}:{result}"
    
    return result

instr_addr = 0
for line in Lines:
    if line.isspace() or ':' in line or line[0] == '#' or line[0:2] == '/*' or line[0:2] == '*/' or line[0:2] == ' *':
        continue
    elif '#' in line:
        print(line)
        tests = re.split(r'\s|,', line[line.find('#') + 1:])
        for test in tests:
            new_test = get_test(test, instr_addr)
            print(new_test)
            if new_test != "":
                test_file.append(new_test)
    instr_addr += 4


# save test_file to a file named test.tmp
with open('runtime_test.tmp', 'w') as f:
    for item in test_file:
        f.write("%s\n" % item)

final_test_file = []
# go through Line in reverse order
for line in reversed(Lines):
    if line.isspace() or ':' in line:
        continue
    elif line[0] == '#':
        tests = re.split(r'\s|,', line[1:])
        for test in tests:
            new_test = get_test(test, instr_addr, True)
            if new_test != "":
                final_test_file.append(new_test)
    else:
        break

# save test_file to a file named test.tmp
with open('final_test.tmp', 'w') as f:
    for item in final_test_file:
        f.write("%s\n" % item)
