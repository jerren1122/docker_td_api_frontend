    package main

import (
	"fmt"
	"log"
	"net/http"
   "encoding/json"
	"github.com/gorilla/mux"
	"os/exec"
	"io/ioutil"
	"strings"
)

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/compilation", compilation)
	log.Fatal(http.ListenAndServe(":8083", router))
}

func compilation(w http.ResponseWriter, r *http.Request) {
	reqBody,_:= ioutil.ReadAll(r.Body)
	string_output:= strings.Replace(string(reqBody), "\n", "", -1)
	cmd := exec.Command("ruby", "../compilation/compilation.rb", string_output)
	output,_ := cmd.Output()
	json.NewEncoder(w).Encode(string(output)) }

