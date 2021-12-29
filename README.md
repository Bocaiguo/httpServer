// requestResponse project main.go
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
)

func handerCheck(w http.ResponseWriter, r *http.Request) {
	//fmt.Println("os.Environ()====", os.Environ())
	//JAVA_HOME := os.Getenv("JAVA_HOME")

	//遍历Evniron 信息并且加入到response的header
	for i, v := range os.Environ() {
		w.Header().Add(string(i), string(v))
		//fmt.Println("i====", string(i), "v====", string(v))
	}

	//遍历request中的header，并写入到response的header
	for k, v := range r.Header {
		w.Header().Add(k, strings.Join(v, " "))
		//fmt.Println("@@@@@@@@", k, strings.Join(v, " "))
	}

	log.Println("/ ClientAddress is " + r.RemoteAddr + " Status Code is " + http.StatusText(200))
}

func hander(w http.ResponseWriter, r *http.Request) {
	//response页面上返回"return ok!!!!!!!!!!"
	io.WriteString(w, "return ok!!!!!!!!!!\n")
	//获取request请求用户信息，如果没有获取打印出"hello bobo"
	user := r.URL.Query().Get("user")
	//fmt.Println("user---:", user)
	if user != "" {
		io.WriteString(w, fmt.Sprintf("hello [%s]\n", user))
	} else {
		io.WriteString(w, "hello bobo\n")
	}
	//记录request的访问IP地址，并返回200
	log.Println("/healthz ClientAddress is " + r.RemoteAddr + " Status Code is " + http.StatusText(200))
}

func main() {
	http.HandleFunc("/", handerCheck)
	http.HandleFunc("/healthz", hander)
	//开启访问地址与访问端口,如果出错，直接返回
	err := http.ListenAndServe(":8027", nil)

	if err != nil {
		fmt.Println("error is :", err.Error())
		return
	}
}
