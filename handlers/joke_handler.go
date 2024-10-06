package handlers

import (
	"encoding/json"
	"github.com/elden43/joker/jokes"
	"github.com/elden43/joker/models"
	"net/http"
)

func JokeHandler(allJokes []models.Joke) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		joke := jokes.RandomJoke(allJokes)
		json.NewEncoder(w).Encode(joke)
	}
}
