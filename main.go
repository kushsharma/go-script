package main

import (
	"fmt"
	"github.com/kushsharma/go-script/structs"
	"github.com/traefik/yaegi/interp"
	"github.com/traefik/yaegi/stdlib"
	"io/ioutil"
	"reflect"
)

func main() {
	i := interp.New(interp.Options{})
	stdlib.Symbols["github.com/kushsharma/go-script/structs/structs"] = map[string]reflect.Value{
		"Request": reflect.ValueOf((*structs.Request)(nil)),
		"Response": reflect.ValueOf((*structs.Response)(nil)),
	}
	i.Use(stdlib.Symbols)

	src, err := ioutil.ReadFile("./scripts/date.go")
	if err != nil {
		panic(err)
	}

	_, err = i.Eval(string(src))
	if err != nil {
		panic(err)
	}

	v, err := i.Eval("scripts.Do")
	if err != nil {
		panic(err)
	}
	bar := v.Interface().(func(request structs.Request) (structs.Response, error))

	resp, err := bar(structs.Request{URL: "http://worldclockapi.com/api/json/utc/now"})
	if err != nil {
		panic(err)
	}
	fmt.Println(resp)
}