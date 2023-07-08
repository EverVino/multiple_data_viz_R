# Función para obtener la lista de palabras que 
# se van a omtir de la nube de la palabras
def get_conj_words():
    with open("conjunciones_es.txt", "r") as f:
        reader = f.readlines()
    lst = set()
    for line in reader:
        lst.add(line.rstrip())
    
    return lst

"""
Esta función extraer las palabras más repetidas en la constitución
polítca de Bolivia y lo exporta a un archivo csv
"""
with open("constitucion_Bolivia.txt", "r") as f:
    reader = f.read()

reader = reader.lower()
print(reader[:60])
punctuations = "!" + "#$%&'()*+,-./:;<=>?@[\]^_`{|}~¿1234567890" + '"'

for p in punctuations:
    if p in reader:
      reader = reader.replace(p, "")

lst = get_conj_words()

word_list=reader.split()

freq = dict()
for word in word_list:
    if word not in freq:
        freq[word] = 0
    freq[word] += 1

for k in freq.copy():
    if k in lst:
        freq.pop(k)

freq = dict(sorted(freq.items(), reverse = True, key= lambda x:x[1]))

file = open("count_words.csv", "w")
file.write("word, count")
file.write("\n")
for w, v in freq.items():
    file.write(f"{w}, {v}")
    file.write("\n")
file.close()

