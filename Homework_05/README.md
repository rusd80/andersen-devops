## Homework:

Build a docker container for your python app!
• this time it needs to listen port `8080`, HTTP only
• the lighter in terms of image size it is – the more points you get
• the one who builds the `smallest` image gets even more points!
Hints:
• use the `minimal` possible setup
• 100MB is a lot ;-)

#### Image is available on Docker Hub and has size: 8.4 Mb
![dockerhub](https://i.imgur.com/h2G0lTW.png[/img])
https://hub.docker.com/repository/docker/rusd80/devops

Application receives 2-literal code of country and returns some info about this country: name, capital, currency, languages.

То build: `docker build . -t rusd80/devops:tiny`
To run: `docker run -it -p 8080:8080 rusd80/devops:v1`

### Usage with CLI:
```
curl -d'{"CountryCode":"ru"}' http://127.0.0.1:8080
```
### Result:
```
Country: Russia, capital: Moscow, currency: RUB, languages(native): Russian(Русский)
```
### Using browser:
```
http://127.0.0.1:8080/country/jp
```
### Result:
```
country: Japan, capital: Tokyo, currency: JPY, languages(native): Japanese(日本語)
```