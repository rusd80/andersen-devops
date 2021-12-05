from flask import Flask, json, request
from json import load

# function returns info about country
def get_info(query: str) -> str:
    with open('countries.json', 'r', encoding='utf-8') as file:
        countries = load(file)
    with open('languages.json', 'r', encoding='utf-8') as file:
        languages = load(file)
    if len(query) == 2 and query.isalpha():
        try:
            result = "country: {0}, \ncapital: {1}, \ncurrency: {2}, \nlanguages(native): "\
                .format(countries[query]["name"], countries[query]["capital"], countries[query]["currency"],)
            native = []
            for lang in countries[query]["languages"]:
                native.append("{0}({1})".format(languages[lang]["name"], languages[lang]["native"]))
            result += ", ".join(native)
            result += "\n"
        except KeyError:
            result = "country not found"
    else:
        result = "data incorrect"
    return result


app = Flask(__name__)


@app.route("/country/<path:sub>")
def get_sub(sub):
    return get_info(sub.upper())


@app.route('/', methods=['GET', 'POST'])
def get_query():
    try:
        query = json.loads(request.get_data())["CountryCode"].upper()
    except Exception:
        return "data incorrect"
    return get_info(query)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)