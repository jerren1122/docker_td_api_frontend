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

func homeLink(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to Jurassic Park")
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/compilation", compilation)
	log.Fatal(http.ListenAndServe(":8083", router))
}

func compilation(w http.ResponseWriter, r *http.Request) {
	reqBody,err:= ioutil.ReadAll(r.Body)
	string_output:= strings.Replace(string(reqBody), "\n", "", -1)
	cmd := exec.Command("ruby", "../compilation/compilation.rb", string_output)
	output,err := cmd.Output()
	if (err != nil) {
		fmt.Fprintf(w, "Anarchy!!!")
	} else {
	json.NewEncoder(w).Encode(string(output)) }

}
