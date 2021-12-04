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
	taskEmpty   string     = "This homework is not done!"
	cmdErrMsg   string     = "Unknown command. Please try /help."
	taskListErr string     = "Can't get task list from GitHub API"
	topicErr    string     = "Can't get topics from GitHub API"
	statErr     string     = "Can't get statistics from GitHub API"
	topicEmpty  string     = "Topics of this repository are not defined"
	statEmpty   string     = "Commit statistics data is empty"
	taskList    []homeWork // array of jsons to get from GitHub API
	response    string
	start       string = "Hello! This bot can get info about your homeworks from Github repository " +
		"Use /help command to learn how to use bot."
	help string = "Commands available:\n/tasks shows list of completed homeworks in your repo\n" +
		"/task##, where ## is number of homework, shows URL to this homework directory\n" +
		"/git - returns URL of your repository\n" +
		"/topics - returns repository's list of topics\n" +
		"/stats - returns number of commits made this week and previous week"
	topicList  allTopics   // variable for request with topics
	commitList commitStats // variable for request with commit statistics
)

// handler of received requests from telegram via webhook
func webHookHandler(_ http.ResponseWriter, req *http.Request) {
	// Create our web hook request body type instance
	body := &webHookReqBody{}
	// Decodes the incoming request into our custom webhook req body type
	if err := json.NewDecoder(req.Body).Decode(body); err != nil {
		log.Println("An error occurred (webHookHandler)", err)
		return
	}
	// If the known command received call the sendReply function
	botMessage := strings.ToLower(body.Message.Text)
	// command checking
	if botMessage == "/tasks" || botMessage == "/topics" || botMessage == "/stats" || botMessage == "/task" ||
		botMessage == "/start" || botMessage == "/git" || botMessage == "/help" || strings.HasPrefix(botMessage, "/task") {
		err := sendReply(body.Message.Chat.ID, body.Message.Text)
		if err != nil {
			log.Println("sendReply method error", err)
			return
		}
	} else {
		// case with unknown command
		err := sendReply(body.Message.Chat.ID, "/badCommand")
		if err != nil {
			log.Println("sendReply method error", err)
			return
		}
	}
}

// function sends response to telegram via http.Post
func sendReply(chatID int64, command string) error {
	text, err := commandHandler(command)
	if err != nil {
		log.Println("error from command handler", err)
	}
	//Creates an instance of sendMessageReqBody type
	reqBody := &sendMessageReqBody{
		ChatID: chatID,
		Text:   text,
	}
	// Convert our custom type into json format
	reqBytes, err := json.Marshal(reqBody)
	if err != nil {
		log.Println("request body message marshal error", err)
		return err
	}
	// Make a request to send our message using the POST method to the telegram bot API
	resp, err := http.Post(
		"https://api.telegram.org/bot"+botToken+"/"+"sendMessage",
		"application/json",
		bytes.NewBuffer(reqBytes),
	)
	if err != nil {
		log.Println("http.post error while sending message to telegram", err)
		return err
	}
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			log.Fatalln(err)
		}
	}(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return errors.New("unexpected status" + resp.Status)
	}
	return err
}

// handler of commands received from telegram
func commandHandler(command string) (string, error) {
	log.Println("Command handling: " + command)
	switch command {
	case "/tasks":
		response, err := fetchTasks()
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
		return response, err
	case "/stats":
		response, err := getStats()
		return response, err
	case "/git":
		return "github.com" + repo, nil
	case "/badCommand":
		response = cmdErrMsg
		cmdErr := errors.New("unknown command received from telegram")
		log.Println(cmdErr)
		return response, nil
	default:
		// case of task## with number
		pattern := re.MustCompile("/task([0-9]+)")
		// if command consists pattern
		if pattern.MatchString(command) {
			taskList, err := fetchTasks()
			if err != nil {
				log.Println("get task list error", err)
				return taskListErr, err
			}
			taskNumber := pattern.FindStringSubmatch(command)[1]
			if len(taskList) > 0 {
				response = getTaskUrl(taskNumber)
			}
		} else {
			response = cmdErrMsg
		}
		return response, nil
	}
}

// function fetching content from GitHub repository
func fetchTasks() (string, error) {
	resp, err := http.Get(apiUrlContents)
	if err != nil {
		log.Println("can't get tasks", err)
		return taskListErr, err
	}
	if resp.Body != nil {
		defer func(Body io.ReadCloser) {
			closeErr := Body.Close()
			if closeErr != nil {
				log.Fatalln(closeErr)
			}
		}(resp.Body)
		err := json.NewDecoder(resp.Body).Decode(&taskList)
		if err != nil {
			log.Println("tasks decoding error", err)
			return taskListErr, err
		}
	}
	response = "The next tasks are done:\n" // response string initial line
	// returns true is chr not letter and not number
	checkName := func(chr rune) bool {
		return !unicode.IsLetter(chr) && !unicode.IsNumber(chr)
	}
	for i := range taskList {
		if strings.HasPrefix(taskList[i].Name, "Homework") {
			// split of string by not letter and not number, get second element/
			taskNum := strings.FieldsFunc(taskList[i].Name, checkName)[1]
			// add line with task##
			response += fmt.Sprintf("%d. %s", i+1, fmt.Sprintf("/task%s\n", taskNum))
		}
	}
	return response, nil
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
		url = taskEmpty
	}
	return url
}

// function retrieves topics from GitHub repository
func getTopics() (string, error) {
	response, err := http.Get(apiUrlTopics)
	if err != nil {
		log.Println("can't get topics", err)
		return topicErr, err
	}
	if response.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {
				log.Fatalln(err)
			}
		}(response.Body)
		err := json.NewDecoder(response.Body).Decode(&topicList)
		if err != nil {
			log.Println("can't decode response body", err)
			return topicErr, err
		}
	}
	if len(topicList.Names) > 0 {
		// build a string with list of topics
		return "Topics of this repository are: " + strings.Join(topicList.Names, ", "), nil
	} else {
		// topic list can be empty if not specified
		return topicEmpty, nil
	}
}

// function retrieves commit statistics from GitHub repository
func getStats() (string, error) {
	response, err := http.Get(apiUrlCommits)
	if err != nil {
		log.Println("can't get commit statistics", err)
		return statErr, err
	}
	if response.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {
				log.Fatalln(err)
			}
		}(response.Body)
		err := json.NewDecoder(response.Body).Decode(&commitList)
		if err != nil {
			log.Println("can't decode response body", err)
			return statErr, err
		}
	}
	if len(commitList.All) > 0 {
		// build a string with commit statistics
		respMessage := "Statistics of commits: \n" +
			"This week: " + strconv.Itoa(commitList.All[len(commitList.All)-1]) + " \n" +
			"Previous week: " + strconv.Itoa(commitList.All[len(commitList.All)-2])
		return respMessage, nil
	} else {
		return statEmpty, nil
	}
}
