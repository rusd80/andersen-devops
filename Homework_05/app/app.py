from flask import Flask, json, request
from json import load

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def get_query():
    try:
        query = json.loads(request.get_data())["CountryCode"].upper()
    except Exception:
        return "data incorrect"
    with open('countries.json', 'r', encoding='utf-8') as file:
        countries = load(file)
    with open('languages.json', 'r', encoding='utf-8') as file:
        languages = load(file)

    if len(query) == 2 and query.isalpha():
        try:
            result = "Country: {0}, capital: {1}, currency: {2}, languages(native): "\
                .format(countries[query]["name"], countries[query]["capital"], countries[query]["currency"],)
            native = []
            for lang in countries[query]["languages"]:
                native.append("{0}({1})".format(languages[lang]["name"], languages[lang]["native"]))
            result += ", ".join(native)
        except KeyError:
            result = "country not found"
    else:
        result = "data incorrect"
    return result


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
