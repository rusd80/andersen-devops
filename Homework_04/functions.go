package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	re "regexp"
	"strconv"
	"strings"
	"unicode"
)

var (
	taskErr  string     = "This homework is`nt done!"
	cmdErr   string     = "Unknown command. Please try /help."
	taskList []homeWork // array of jsons to get from GitHub API
	response string
	start    string = "Hello! This bot can get info about your homeworks from Github repository " +
		"Use /help command to learn how to use bot."
	help string = "Commands available:\n/tasks shows list of completed homeworks in your repo\n" +
		"/task##, where ## is number of homework, shows URL to this homework directory\n" +
		"/git - returns URL of your repository\n" +
		"/topics - returns repository's list of topics\n" +
		"/stats - returns number of commits made this week and previous week"
	topicList  allTopics
	commitList commitStats
)

// handler of sent requests from bot using webhook
func webHookHandler(rw http.ResponseWriter, req *http.Request) {
	// Create our web hook request body type instance
	body := &webHookReqBody{}
	// Decodes the incoming request into our custom webhook req body type
	if err := json.NewDecoder(req.Body).Decode(body); err != nil {
		log.Printf("An error occured (webHookHandler)")
		log.Panic(err)
		return
	}
	// If the known command received call the sendReply function
	botMessage := strings.ToLower(body.Message.Text)
	if botMessage == "/tasks" || botMessage == "/topics" || botMessage == "/stats" || botMessage == "/task" || botMessage == "/start" || botMessage == "/git" || botMessage == "/help" || strings.HasPrefix(botMessage, "/task") {
		err := sendReply(body.Message.Chat.ID, body.Message.Text)
		if err != nil {
			log.Panic(err)
			return
		}
	} else {
		err := sendReply(body.Message.Chat.ID, "/badCommand")
		if err != nil {
			log.Panic(err)
			return
		}
	}
}

// function sends response to bot via http.Post
func sendReply(chatID int64, command string) error {
	text, err := commandHandler(command)
	if err != nil {
		return err
	}
	//Creates an instance of our custom sendMessageReqBody Type
	reqBody := &sendMessageReqBody{
		ChatID: chatID,
		Text:   text,
	}
	// Convert our custom type into json format
	reqBytes, err := json.Marshal(reqBody)
	if err != nil {
		return err
	}
	// Make a request to send our message using the POST method to the telegram bot API
	resp, err := http.Post(
		"https://api.telegram.org/bot"+botToken+"/"+"sendMessage",
		"application/json",
		bytes.NewBuffer(reqBytes),
	)
	if err != nil {
		return err
	}
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
		}
	}(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return errors.New("unexpected status" + resp.Status)
	}
	return err
}

// function of fetching content from GitHub repository
func fetchTasks() (string, error) {
	resp, getErr := http.Get(apiUrlContents)
	if getErr != nil {
		log.Fatal(getErr)
	}
	if resp.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {
				log.Fatal(err)
			}
		}(resp.Body)
		decodeErr := json.NewDecoder(resp.Body).Decode(&taskList)
		if decodeErr != nil {
			log.Fatal(decodeErr)
		}
	}
	response = "The next tasks are done:\n"
	f := func(c rune) bool {
		return !unicode.IsLetter(c) && !unicode.IsNumber(c)
	}
	for i := range taskList {
		if strings.HasPrefix(taskList[i].Name, "Homework") {
			taskNum := strings.FieldsFunc(taskList[i].Name, f)[1]
			response += fmt.Sprintf("%d. %s", i+1, fmt.Sprintf("/task%s\n", taskNum))
		}
	}
	return response, getErr
}

// handler of commands received from bot
func commandHandler(command string) (string, error) {
	switch command {
	case "/tasks":
		response, err := fetchTasks()
		if err != nil {
			log.Fatal(err)
		}
		return response, err
	case "/start":
		response = start
		return response, nil
	case "/task":
		response = "You should specify number of homework: task##"
		return response, nil
	case "/help":
		response = help
		return response, nil
	case "/topics":
		response, err := getTopics()
		if err != nil {
			log.Fatal(err)
		}
		return response, nil
	case "/stats":
		response, err := getStats()
		if err != nil {
			log.Fatal(err)
		}
		return response, nil
	case "/git":
		return "github.com" + repo, nil
	case "/badCommand":
		response = cmdErr
		return response, nil
	default:
		pattern := re.MustCompile("/task([0-9]+)")
		if pattern.MatchString(command) {
			taskNumber := pattern.FindStringSubmatch(command)[1]
			response = getTaskUrl(taskNumber)
		} else {
			response = cmdErr
		}
		return response, nil
	}
}

// Retrieves a URL for a done homework
func getTaskUrl(taskNum string) string {
	var url string
	taskName := fmt.Sprintf("Homework_%s", taskNum)
	for i := range taskList {
		if taskList[i].Name == taskName {
			url = taskList[i].URL
			break
		}
	}
	if url == "" {
		url = taskErr
	}
	return url
}

// function gets topics from GitHub repository
func getTopics() (string, error) {
	response, getErr := http.Get(apiUrlTopics)
	if getErr != nil {
		log.Fatal(getErr)
	}
	if response.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {
				log.Fatal(err)
			}
		}(response.Body)
		err := json.NewDecoder(response.Body).Decode(&topicList)
		if err != nil {
			return "", err
		}
	}
	if len(topicList.Names) > 0 {
		return "Topics of this repository are: " + strings.Join(topicList.Names, ", "), getErr
	} else {
		return "Topics of this repository are not specified", getErr
	}
}

// function gets commit statistics from GitHub repository
func getStats() (string, error) {
	response, getErr := http.Get(apiUrlCommits)
	if getErr != nil {
		log.Fatal(getErr)
	}
	if response.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {
				log.Fatal(err)
			}
		}(response.Body)
		err := json.NewDecoder(response.Body).Decode(&commitList)
		if err != nil {
			return "", err
		}
	}
	if len(commitList.All) > 0 {
		respMessage := "Statistics of commits: \n" +
			"This week: " + strconv.Itoa(commitList.All[len(commitList.All)-1]) + " \n" +
			"Previous week: " + strconv.Itoa(commitList.All[len(commitList.All)-2])
		return respMessage, getErr
	} else {
		return "Commit statistics are empty.", getErr
	}
}
