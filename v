import json

def dynamodb_to_dict(item):
    """Converte um item DynamoDB serializado em um dicionário Python padrão."""
    if isinstance(item, dict):
        # Verifica o tipo do valor DynamoDB e converte para o tipo Python correspondente
        if "S" in item:  # String
            return item["S"]
        elif "N" in item:  # Number
            return int(item["N"])
        elif "M" in item:  # Map (dicionário)
            return {key: dynamodb_to_dict(value) for key, value in item["M"].items()}
        elif "L" in item:  # List (lista)
            return [dynamodb_to_dict(i) for i in item["L"]]
        elif "BOOL" in item:  # Boolean
            return item["BOOL"]
        elif "NULL" in item:  # Null
            return None
        else:
            raise ValueError(f"Tipo DynamoDB não suportado: {item}")
    return item

# Caminho para o arquivo JSON do DynamoDB
file_path = 'caminho/para/sua/pasta/seu_arquivo.json'

# Carregar o arquivo JSON do DynamoDB
with open(file_path, 'r') as f:
    dynamodb_json = json.load(f)

# Deserializar o JSON DynamoDB para um dicionário Python
try:
    deserialized_data = [dynamodb_to_dict(item) for item in dynamodb_json]
except ValueError as e:
    print(f"Ocorreu um erro: {e}")
    print("Item problemático:", item)
    raise  # Relança a exceção para parar a execução se necessário

# Exibir o resultado
print(json.dumps(deserialized_data, indent=4))
