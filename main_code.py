def get_max_value_pair(text):
    # Inicializamos un diccionario vacío
    result_dict = {}

    # Dividimos el texto en líneas
    lines = text.split('\n')

    # Procesamos cada línea
    for line in lines[:-1]:
        # Dividimos la línea en clave y valor
        key, value = line.split(': ')
        # Convertimos el valor a float y lo añadimos al diccionario
        result_dict[key] = float(value)

    # Encontrar el par clave-valor con el mayor valor
    max_key = max(result_dict, key=result_dict.get)
    max_value = result_dict[max_key]

    # Devolver el resultado como un diccionario
    return {max_key: max_value}
    
 
 def get_max_value_pair(text):
    # Inicializamos un diccionario vacío
    result_dict = {}

    # Dividimos el texto en líneas
    lines = text.split('\n')

    # Procesamos cada línea
    for line in lines[:-1]:
        # Dividimos la línea en clave y valor
        key, value = line.split(': ')
        # Convertimos el valor a float y lo añadimos al diccionario
        result_dict[key] = float(value)

    # Encontrar el par clave-valor con el mayor valor
    max_key = max(result_dict, key=result_dict.get)
    max_value = result_dict[max_key]

    # Devolver el resultado como un diccionario
    return {max_key: max_value}
