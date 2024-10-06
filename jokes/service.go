package jokes

import (
	"github.com/elden43/joker/models"
	"math/rand"
)

func RandomJoke(jokes []models.Joke) models.Joke {
	return jokes[rand.Intn(len(jokes))]
}
