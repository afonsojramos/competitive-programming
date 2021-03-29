#write to a file
def write_file(filename, contents="", mode="w"):
    with open(filename, mode, encoding="utf-8") as file:
        file.write(contents)
#append to a file
def append_file(filename, contents=""):
    write_file(filename, contents, "a")
#read a file
def read_file(filename):
    with open(filename, "r", encoding="utf-8") as file:
        return file.read()
# read a file line by line
def read_file_it(filename):
    with open(filename, "r", encoding="utf-8") as file:
        for line in file: yield line
# line to map of ints
def mints(line):
    return map(int, line.strip().split(" "))
# line to list of ints
def lints(line):
    return list(mints(line))


def printL(l): # print a list one element per line
    [print(ele) for ele in l]
def printD(d): # print a dict one pair per line
    [print("%s: %s" % ele) for ele in d.items()]