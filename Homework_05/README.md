## Homework:

Build a docker container for your python app!
• this time it needs to listen port `8080`, HTTP only
• the lighter in terms of image size it is – the more points you get
• the one who builds the `smallest` image gets even more points!
Hints:
• use the `minimal` possible setup
• 100MB is a lot ;-)

### Size of image: 9.79 Mb.

Application receives 2-literal code of country and returns some info about this country: name, capital, currency, languages.

То build: `docker build . -t rusd80/devops:tiny`
To run: `docker run -it -p 8080:8080 rusd80/devops:v1`

#### Compressed by Docker Hub image size is 9.07 mB

## Usage:
```
curl -d'{"CountryCode":"ru"}' http://127.0.0.1:8080
```
## Result:
```
Country: Russia, capital: Moscow, currency: RUB, languages(native): Russian(Русский)
```