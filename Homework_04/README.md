### Task 4

## This bot can get repository list from Github

### Bot provides this commands:
1. /start - greeting and basic info about bot
2. /help - describing of commands
3. /tasks - get full list of your done homeworks directories 
4. /task# - get URL to directory of homework number #

### If you don't have "white" IP, use tunnel [ngrok](https://ngrok.com/)
```
ngrok by @inconshreveable 
                                                                                
Session Status                online                                            
Session Expires               1 hour, 59 minutes                                
Version                       2.3.40                                            
Region                        United States (us)                                
Web Interface                 http://127.0.0.1:4040                             
Forwarding                    http://84e1-85-142-172-180.ngrok.io -> http://loca
Forwarding                    https://84e1-85-142-172-180.ngrok.io -> http://loc
                                                                                
Connections                   ttl     opn     rt1     rt5     p50     p90       
                              0       0       0.00    0.00    0.00    0.00      
                                                                             
```
## To run bot:
1. Clone repo with `git clone` command 
2. Create your own bot using `BotFather` and save `SECRET TOKEN`
3. Создайте в папке проекта файл `.env` и внесите в него секретные переменные:

`TOKEN="2144052527:AAELCMqXtbt9jKclUW...` - your bot's secret token

`PORT="8080"` - port that will be used by your app

`REPO="/rusd80/andersen-devops"` - your repository on GitHub.com

Also, you should set `WEBHOOK` to allow telegram send POST requests to your app:
```
curl --location --request POST 'https://api.telegram.org/bot2144052527:AAELCMqXtbt9jKclUWVZj####SECRET####/setWebhook?url=https://1cd2-176-53-210-50.ngrok.io'
```
