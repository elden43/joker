package main

import (
	"github.com/elden43/joker/config"
	"github.com/elden43/joker/handlers"
	"github.com/elden43/joker/models"
	"log"
	"net/http"
)

func main() {
	appConfig := config.New()

	jokes, err := models.ReadJokes(appConfig.JokesPath)
	if err != nil {
		log.Fatalf("Error reading jokes: %v", err)
	}

	http.HandleFunc("/", handlers.JokeHandler(jokes))
	log.Println("Starting server on port", appConfig.Port)
	if err := http.ListenAndServe(":"+appConfig.Port, nil); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
