package scripts

import (
	"encoding/json"
	"github.com/kushsharma/go-script/structs"
	"net/http"
)

func Do(request structs.Request) (structs.Response, error) {
	resp, err := http.Get(request.URL)
	if err != nil {
		return structs.Response{}, err
	}
	data := map[string]interface{}{}
	if err = json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return structs.Response{}, err
	}
	return structs.Response{
		Data: data["currentDateTime"].(string),
	}, nil
}
